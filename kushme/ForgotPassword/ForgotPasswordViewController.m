//
//  ForgotPasswordViewController.m
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.emailField becomeFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailField)
        [self tapSendButton:nil];
    return YES;
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.emailField resignFirstResponder];
}


#pragma mark -
#pragma mark - Main methods
- (IBAction)loginAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tapSendButton:(id)sender {
    
    NSString* email = self.emailField.text;
    if (!email || [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [self.emailField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type email address" onVC:self];
        return;
    }
    if (![UtilManager validateEmail:email]) {
        [self.emailField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type correct email address" onVC:self];
        return;
    }
    
    [self.emailField resignFirstResponder];
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] forgotPasswordWithEmail:email success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"ForgotPassword : %@", responseObject);
#endif
        
        if (responseObject) {
            NSString* message = [responseObject valueForKey:key_message];
            if (message) {
                [[AlertManager sharedManager] showErrorAlert:message onVC:self];
            }
        }
        
        [SVProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}

@end
