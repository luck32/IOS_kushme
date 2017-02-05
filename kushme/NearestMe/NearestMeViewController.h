//
//  NearestMeViewController.h
//  kushme
//
//  Created by Yanny on 5/16/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearestMeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* searchView;
@property (weak, nonatomic) IBOutlet UIButton* shopSearchButton;
@property (weak, nonatomic) IBOutlet UITextField* shopNameField;
@property (weak, nonatomic) IBOutlet UITextField* strainsField;
@property (weak, nonatomic) IBOutlet UITextField* locationField;

@property (weak, nonatomic) IBOutlet UIView* overlayView;
@property (weak, nonatomic) IBOutlet UIView* nearestMeBorderView;
@property (weak, nonatomic) IBOutlet UIView* favoriteBorderView;
@property (weak, nonatomic) IBOutlet UITableView* nearestMeTableView;
@property (weak, nonatomic) IBOutlet UITableView* favoriteTableView;

@property (strong, nonatomic) NSMutableArray* nearestMeResults;
@property (strong, nonatomic) NSMutableArray* favoriteResults;

- (IBAction)tapTabButton:(UIButton*)sender;
- (IBAction)tapShopSearchButton:(UIButton*)sender;

- (IBAction)cancelToSearchShop;
- (IBAction)resignInputFields;

- (IBAction)unwindToShopsVC:(UIStoryboardSegue*)segue;


@end