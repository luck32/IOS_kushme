//
//  SignupViewController.m
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
    [self.usernameField becomeFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameField)
        [self.emailAddressField becomeFirstResponder];
    else if(textField == self.emailAddressField)
        [self.passwordField becomeFirstResponder];
    else
        [self tapSignupButton:nil];
    return YES;
}

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
- (IBAction)loginAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)tapSignupButton:(id)sender {
    
    [self resignInputFields];
    
    NSString* username = self.usernameField.text;
    if (!username || [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [self.usernameField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type username" onVC:self];
        return;
    }
    
    NSString* email = self.emailAddressField.text;
    if (!email || [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [self.emailAddressField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type email address" onVC:self];
        return;
    }
    if (![UtilManager validateEmail:email]) {
        [self.emailAddressField becomeFirstResponder];
        [[AlertManager sharedManager] showErrorAlert:@"Please type correct email address" onVC:self];
        return;
    }
    
    NSString* password = self.passwordField.text;
    
    
    [SVProgressHUD show];

    [[APIManager sharedManager] signupWithUsername:username email:email password:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"Signup : %@", responseObject);
#endif
        
        NSString* signupResult = [responseObject valueForKey:key_message];
        if (signupResult && [signupResult isEqualToString:key_Done]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSString *message = [NSString stringWithFormat:@"Failed to signup. %@", [responseObject valueForKey:key_response]];
            [[AlertManager sharedManager] showErrorAlert:message onVC:self];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}

- (IBAction)resignInputFields {
    [self.usernameField resignFirstResponder];
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
