//
//  ForgotPasswordViewController.h
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField* emailField;


- (IBAction)tapSendButton:(id)sender;
- (IBAction)loginAction:(id)sender;


@end
