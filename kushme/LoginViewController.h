//
//  ViewController.h
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate;

@interface LoginViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField* usernameField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

@property (strong, nonatomic) id<LoginDelegate> loginDelegate;

- (IBAction)cancelAction:(id)sender;

@end

@protocol LoginDelegate <NSObject>
@required
- (void)kushmeDidLogin;

@end