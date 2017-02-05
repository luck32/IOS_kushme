//
//  ViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.usernameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resignInputFields {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameField)
        [self.passwordField becomeFirstResponder];
    else if(textField == self.passwordField)
        [self tapLoginButton:nil];
    return YES;
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self resignInputFields];
}

#pragma mark -
#pragma mark - Main methods

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapLoginButton:(id)sender {
    
    // Test code
//    self.usernameField.text = @"jiangmeimei0906@hotmail.com";
//    self.passwordField.text = @"123";
    
    [self resignInputFields];
    
    NSString* username = self.usernameField.text;
    if (!username || [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [self.usernameField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type username" onVC:self];
        return;
    }
    
    NSString* password = self.passwordField.text;
    
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] loginWithUsername:username password:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"Login : %@", responseObject);
#endif
        
        [SVProgressHUD dismiss];
        
        NSString* loginResult = [responseObject valueForKey:key_message];
        if (loginResult && [loginResult isEqualToString:key_Success]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(kushmeDidLogin)])
                [self.loginDelegate kushmeDidLogin];
        }
        else {
            [[AlertManager sharedManager] showErrorAlert:@"Failed to signup" onVC:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
    
}

@end
