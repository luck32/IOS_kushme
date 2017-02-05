//
//  ShopMenuViewController.h
//  kushme
//
//  Created by Yanny on 5/30/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* menuLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel* menuNameLabel;

@end


@interface ShopMenuItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* gInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel* oneOfEightInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel* oneOfFourInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel* oneOfTwoInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel* ozInfoLabel;

@end


@interface ShopMenuViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary* shopInfo;

@end
