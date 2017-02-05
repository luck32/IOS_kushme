//
//  CommentViewController.m
//  kushme
//
//  Created by Nicolas Rostov on 22/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "CommentViewController.h"
#import "APIManager.h"

@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentView;

-(IBAction)doneAction:(id)sender;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    [self.commentView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notif {
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    UIEdgeInsets insets = self.commentView.contentInset;
    insets.bottom = keyboardBounds.size.height;
    self.commentView.contentInset = insets;
}

- (void)keyboardWillHide:(NSNotification*)notif {
    UIEdgeInsets insets = self.commentView.contentInset;
    insets.bottom = 0;
    self.commentView.contentInset = insets;
}

-(IBAction)doneAction:(id)sender {
    [SVProgressHUD show];
    [[APIManager sharedManager] postComment:self.commentView.text
                                  toPicture:[self.pictureData[key_post_pic_id] intValue]
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        [SVProgressHUD showInfoWithStatus:@"Done"];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    }];
}

@end
