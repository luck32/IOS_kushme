//
//  ShopMapViewController.h
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* searchView;
@property (weak, nonatomic) IBOutlet UIButton* shopSearchButton;
@property (weak, nonatomic) IBOutlet UITextField* shopNameField;
@property (weak, nonatomic) IBOutlet UITextField* strainsField;
@property (weak, nonatomic) IBOutlet UITextField* locationField;

@property (weak, nonatomic) IBOutlet UIView* overlayView;
@property (weak, nonatomic) IBOutlet MKMapView* shopMapView;

@property (strong, nonatomic) NSMutableArray* shopList;
@property (strong, nonatomic) NSMutableArray* searchResults;

- (IBAction)tapShopSearchButton:(UIButton*)sender;

- (IBAction)cancelToSearchShop;
- (IBAction)resignInputFields;


@end
