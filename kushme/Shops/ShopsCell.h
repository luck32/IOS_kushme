//
//  ShopsCell.h
//  kushme
//
//  Created by Yanny on 5/16/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* shopLogoView;
@property (weak, nonatomic) IBOutlet UILabel* shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* shopDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel* shopAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton* rateButton1;
@property (weak, nonatomic) IBOutlet UIButton* rateButton2;
@property (weak, nonatomic) IBOutlet UIButton* rateButton3;
@property (weak, nonatomic) IBOutlet UIButton* rateButton4;
@property (weak, nonatomic) IBOutlet UIButton* rateButton5;

- (void)setRate:(int)rate;
- (BOOL)isMultilineShopName:(NSString*)shopName;

@end