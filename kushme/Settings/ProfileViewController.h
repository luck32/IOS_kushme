//
//  ProfileViewController.h
//  kushme
//
//  Created by Yanny on 5/19/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* keyLabel;
@property (weak, nonatomic) IBOutlet UITextField* valueField;

@end


@interface ProfilePictureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* keyLabel;

@end


@interface ProfileViewController : UIViewController

- (IBAction)resignInputFields;

@end
