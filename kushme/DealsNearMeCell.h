//
//  DealsNearMeCell.h
//  kushme
//
//  Created by Yanny on 5/17/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealsNearMeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* dealLogoView;
@property (weak, nonatomic) IBOutlet UIImageView* dealNewView;
@property (weak, nonatomic) IBOutlet UIImageView* shopLogoView;
@property (weak, nonatomic) IBOutlet UILabel* dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel* dealDescLabel;
@property (weak, nonatomic) IBOutlet UILabel* locationLabel;

@end
