//
//  FriendsCell.h
//  kushme
//
//  Created by Yanny on 5/21/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* characterView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* addressLabel;

@property (weak, nonatomic) IBOutlet UIView* followWrapper;
@property (weak, nonatomic) IBOutlet UIView* followRequestWrapper;
@property (weak, nonatomic) IBOutlet UIButton* followButton;
@property (weak, nonatomic) IBOutlet UIButton* acceptButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;

- (void)showRequestWrapper:(BOOL)show;

@end
