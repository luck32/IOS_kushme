//
//  ChangePasswordViewController.h
//  kushme
//
//  Created by Yanny on 5/19/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* keyLabel;
@property (weak, nonatomic) IBOutlet UITextField* valueField;

@end


@interface ChangePasswordViewController : UIViewController

@end
