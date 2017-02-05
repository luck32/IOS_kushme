//
//  DealsNearMeViewController.h
//  kushme
//
//  Created by Yanny on 5/17/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealsNearMeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* nearMeBorderView;
@property (weak, nonatomic) IBOutlet UIView* favoriteBorderView;
@property (weak, nonatomic) IBOutlet UITableView* nearMeTableView;
@property (weak, nonatomic) IBOutlet UITableView* favoriteTableView;

@property (strong, nonatomic) NSMutableArray* nearMeResults;
@property (strong, nonatomic) NSMutableArray* favoriteResults;

- (IBAction)tapTabButton:(UIButton*)sender;


@end
