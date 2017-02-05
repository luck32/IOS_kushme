//
//  CropSendViewController.m
//  kushme
//
//  Created by Nicolas Rostov on 15/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "CropSendViewController.h"
#import "uploadPicViewController.h"
#import "APIManager.h"

@interface CropSendViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPost;
@property BOOL postActionFlag;

-(IBAction)postAction:(id)sender;

@end

@implementation CropSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonPost.backgroundColor = self.tabBarController.view.tintColor;
    self.buttonPost.clipsToBounds = YES;
    self.buttonPost.layer.cornerRadius = 6;
    self.buttonPost.layer.borderWidth = 1;
    self.buttonPost.layer.borderColor = [[UIColor clearColor] CGColor];
    
//    if(!CGSizeEqualToSize(self.originalImage.size, self.cropRect.size)) {
//        self.imageView.image = [self cropImage];
//    }
//    else {
        self.imageView.image = self.croppedImage;
//    }
}

- (UIImage *)cropImage {
    CGRect newCropRect = CGRectInset(self.cropRect, -self.cropRect.size.width*0.1, -self.cropRect.size.width*0.1);
    CGRect rect = CGRectMake(newCropRect.origin.x*self.originalImage.scale,
                             newCropRect.origin.y*self.originalImage.scale,
                             newCropRect.size.width*self.originalImage.scale,
                             newCropRect.size.height*self.originalImage.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.originalImage CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.originalImage.scale
                                    orientation:self.originalImage.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.postActionFlag = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound && !self.postActionFlag) {
        uploadPicViewController *uploadController = [[self.navigationController viewControllers] firstObject];
        [uploadController showLatestImagePicker];
    }
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews {
    if(CGSizeEqualToSize(self.originalImage.size, self.cropRect.size)) {
        self.imageView.image = self.croppedImage;
        self.imageView.frame = CGRectInset(self.imageView.frame, self.imageView.frame.size.width*0.1, self.imageView.frame.size.width*0.1);
    }
}

-(IBAction)postAction:(id)sender {
    [SVProgressHUD show];
    NSString *base64Image = [UIImageJPEGRepresentation(self.croppedImage, 0.85) base64EncodedStringWithOptions:0];
    [[APIManager sharedManager] uploadImage:base64Image
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSLog(@"%@", responseObject);
                                        if([responseObject[@"message"] intValue] == 1)
                                            [SVProgressHUD showSuccessWithStatus:@"Image uploaded"];
                                        else
                                            [SVProgressHUD showErrorWithStatus:@"Upload image failed"];
                                        self.postActionFlag = YES;
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"%@", error);
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                    }];
}

@end
