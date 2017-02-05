//
//  ShopDetailViewController.h
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<MapKit/MapKit.h>

@interface ShopReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *reviewerImageView;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *reviewerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDateLabel;

@property (weak, nonatomic) IBOutlet UIButton* rateButton1;
@property (weak, nonatomic) IBOutlet UIButton* rateButton2;
@property (weak, nonatomic) IBOutlet UIButton* rateButton3;
@property (weak, nonatomic) IBOutlet UIButton* rateButton4;
@property (weak, nonatomic) IBOutlet UIButton* rateButton5;

- (void)setRate:(int)rate;

@end



@interface ShopDetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableDictionary* shopInfo;

@property (weak, nonatomic) IBOutlet UITableView* shopReviewTableView;
@property (weak, nonatomic) IBOutlet UIView* shopInfoWrapper;

@property (weak, nonatomic) IBOutlet UIImageView *shopLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnShopType;
@property (weak, nonatomic) IBOutlet UIButton *btnVoutes;
@property (weak, nonatomic) IBOutlet UILabel *lblShopState;
@property (weak, nonatomic) IBOutlet UILabel *lblShopStateBorder;
@property (weak, nonatomic) IBOutlet UILabel *lblCloseDay;
@property (weak, nonatomic) IBOutlet UILabel *lblCloseTime;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowState;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnDirection;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;

- (IBAction)btnWriteReviewTapped:(UIButton *)sender;
- (IBAction)btnViewDealsTapped:(UIButton *)sender;
- (IBAction)btnFollowTapped:(UIButton *)sender;

- (IBAction)btnGetDirectionTapped:(id)sender;
- (NSString *)getWeekday;

- (IBAction)unwindToShopDetailVC:(UIStoryboardSegue*)segue;

@end
