//
//  SignupViewController.h
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField* usernameField;
@property (weak, nonatomic) IBOutlet UITextField* emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

- (IBAction)loginAction:(id)sender;
- (IBAction)tapSignupButton:(id)sender;

@end
