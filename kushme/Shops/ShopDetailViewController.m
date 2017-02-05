//
//  ShopDetailViewController.m
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "writeReviewViewController.h"
#import "ShopMenuViewController.h"
#import "ShopLocation.h"
#import "ShopTimeViewController.h"
#import "DealsDetailViewController.h"

@implementation ShopReviewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setRate:(int)rate {
    
    self.rateButton1.selected = rate >= 1;
    self.rateButton2.selected = rate >= 2;
    self.rateButton3.selected = rate >= 3;
    self.rateButton4.selected = rate >= 4;
    self.rateButton5.selected = rate >= 5;
}

- (NSMutableAttributedString*)getAttrReviewDate:(NSString*)dateString
{
    NSString* reviewDate = [NSString stringWithFormat:@"Rated On: %@", dateString];
    NSMutableAttributedString* attributesString = [[NSMutableAttributedString alloc] initWithString:reviewDate];
    
    NSRange range = [reviewDate rangeOfString:dateString];
    if (range.length > 0)
    {
        [attributesString setAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor],
                                          NSFontAttributeName:[UIFont systemFontOfSize:10.f]} range:range];
    }
    
    return attributesString;
}

@end


@interface ShopDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton* rateButton1;
@property (weak, nonatomic) IBOutlet UIButton* rateButton2;
@property (weak, nonatomic) IBOutlet UIButton* rateButton3;
@property (weak, nonatomic) IBOutlet UIButton* rateButton4;
@property (weak, nonatomic) IBOutlet UIButton* rateButton5;

@property (strong, nonatomic) NSMutableArray* dealInfosOfShop;
@property (strong, nonatomic) NSMutableArray* shopReviews;

@end

@implementation ShopDetailViewController

#define METERS_PER_MILE 1609.344

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo_shop_detail"]];
    
    // load shop detail info
    [self loadShopDetailInfo];
    // load shop pic
    [self performSelectorOnMainThread:@selector(showShopPicture) withObject:nil waitUntilDone:NO];
    // load deals of shop
    [self performSelectorOnMainThread:@selector(loadDealsOfShop) withObject:nil waitUntilDone:NO];
    // load shop reviews
    [self performSelectorOnMainThread:@selector(showShopReviews) withObject:nil waitUntilDone:NO];
}



- (NSString *)getWeekday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
    NSArray *daysOfWeek = @[@"", key_Sunday, key_Monday, key_Tuesday, key_Wednesday, key_Thursday, key_Friday, key_Saturday];
    [nowDateFormatter setDateFormat:@"e"];
    NSInteger weekdayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue];
    NSString *day=[daysOfWeek objectAtIndex:weekdayNumber];
    return day;
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Map View Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"ShopLocation";
    if ([annotation isKindOfClass:[ShopLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"location_pin"];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.shopReviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopReviewCell *cell = (ShopReviewCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopReviewCell" forIndexPath:indexPath];
    
    NSDictionary* shopReview = [self.shopReviews objectAtIndex:indexPath.row];
    if (shopReview) {
        NSString* logoUrl = [shopReview objectForKey:key_reviewer_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [cell.reviewerImageView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        cell.reviewerNameLabel.text = [UtilManager validateResponse:[shopReview objectForKey:key_reviewer_name]];
        cell.reviewTextView.text = [UtilManager validateResponse:[shopReview objectForKey:key_review_message]];
        [cell setRate:[[shopReview objectForKey:key_noofreview] intValue]];
        
        NSString* reviewDate = [UtilManager validateResponse:[shopReview objectForKey:key_review_datetime]];
        if (reviewDate && reviewDate.length > 9)
            reviewDate = [reviewDate substringToIndex:10];
        cell.reviewDateLabel.attributedText = [cell getAttrReviewDate:reviewDate];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowShopTime]) {
        ShopTimeViewController* vc = (ShopTimeViewController*)segue.destinationViewController;
        vc.shopInfo = self.shopInfo;
    }
    else if ([segue.identifier isEqualToString:Segue_ShowShopMenu]) {
        ShopMenuViewController* vc = (ShopMenuViewController*)segue.destinationViewController;
        vc.shopInfo = self.shopInfo;
    }
    else if ([segue.identifier isEqualToString:Segue_ShowWriteReview]) {
        writeReviewViewController *writeReview = (writeReviewViewController *)segue.destinationViewController;
        writeReview.shopId = (NSString*)sender;
    }
    else if ([segue.identifier isEqualToString:Segue_ShowDealsDetail]) {
        NSMutableDictionary* dealInfo = [NSMutableDictionary dictionaryWithDictionary:sender];
        [dealInfo setValuesForKeysWithDictionary:self.shopInfo];
        
        DealsDetailViewController* vc = (DealsDetailViewController*)segue.destinationViewController;
        vc.isSavedDeal = NO;
        vc.dealInfo = dealInfo;
    }
}


#pragma mark Custom methods

- (void)refreshShopInfo {
    //map Zoomed in
    NSNumber *shop_lat=[self.shopInfo objectForKey:key_shop_lat];
    NSNumber *shop_long=[self.shopInfo objectForKey:key_shop_long];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = shop_lat.doubleValue;
    zoomLocation.longitude= shop_long.doubleValue;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    
    //Map Annotations
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.shopInfo objectForKey:key_shop_lat]doubleValue];
    coordinate.longitude = [[self.shopInfo objectForKey:key_shop_long]doubleValue];
    NSString * shop_name=[self.shopInfo objectForKey:key_shop_name];
    NSString *shop_addr=[self.shopInfo objectForKey:key_shop_address];
    ShopLocation *annotation = [[ShopLocation alloc] initWithName:shop_name address:shop_addr coordinate:coordinate] ;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    
    
    NSString* logoUrl = [self.shopInfo objectForKey:key_shop_pic];
    if (logoUrl) {
        logoUrl = logoUrl.stringByRemovingPercentEncoding;
        [self.shopLogoImageView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
    }
    
    self.lblShopName.text = [self.shopInfo valueForKey:key_shop_name];
    [self.lblShopName setFont:[UIFont boldSystemFontOfSize:14.0]];
    
    self.lblDistance.text = [NSString stringWithFormat:@"%d miles", [[self.shopInfo objectForKey:key_distance] intValue]];
    [self.btnShopType setTitle:[self.shopInfo valueForKey:key_shop_type] forState:UIControlStateNormal];
    
    [self setRate:[[self.shopInfo objectForKey:key_shop_rating] intValue]];
    
    [self.btnVoutes setTitle:[[self.shopInfo objectForKey:key_shop_voting] stringByAppendingString:@" votes"] forState:UIControlStateNormal];
    
    NSString* strShopState = [[self.shopInfo valueForKey:key_shop_time] capitalizedString];
    self.lblShopState.text = strShopState;
    
    CGRect rect = [strShopState boundingRectWithSize:CGSizeMake(self.lblShopState.frame.size.width, 9999.f)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: self.lblShopState.font}
                                             context:nil];
    CGRect borderFrame = self.lblShopStateBorder.frame;
    borderFrame.size.width = rect.size.width;
    self.lblShopStateBorder.frame = borderFrame;
    
    NSString *day = [self getWeekday];
    self.lblCloseDay.text = [[NSString stringWithFormat:@"%@", day]capitalizedString];
    
    //Adding these items here as the above statements isn't populating all the keys
    NSString *shop_open_time = [self.shopInfo valueForKey:key_open_time];
    NSString *shop_close_time = [self.shopInfo valueForKey:key_close_time];
    
    NSString *shopTimings = [NSString stringWithFormat:@"%@ - %@", shop_open_time, shop_close_time];
    self.lblCloseTime.text = [[NSString stringWithFormat:@"%@",shopTimings] capitalizedString];
    
    self.btnFollowState.selected = ![[UtilManager validateResponse:[self.shopInfo objectForKey:key_shop_follow_msg]] isEqualToString:key_FOLLOW];
    
    self.lblAddress.text = [self.shopInfo valueForKey:key_shop_address];
    [self.lblAddress sizeToFit];
}

- (void)setRate:(int)rate {
    self.rateButton1.selected = rate >= 1;
    self.rateButton2.selected = rate >= 2;
    self.rateButton3.selected = rate >= 3;
    self.rateButton4.selected = rate >= 4;
    self.rateButton5.selected = rate >= 5;
}

- (void)loadShopDetailInfo {
    
    if (!self.shopInfo)
        return;
    
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    if (!shopId || shopId.length < 1)
        return;
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getShopDetailsWithShopId:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"Shop Details : %@", responseObject);
#endif
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            [self.shopInfo setValuesForKeysWithDictionary:responseObject];
        }
        
        [self refreshShopInfo];
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"Shop Details : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
    }];
}


- (void)showShopPicture
{
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    
    [[APIManager sharedManager] showShopPicture:shopId picCount:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"showShopPicture : %@", responseObject);
#endif
        NSString* logoUrl = [[responseObject firstObject] objectForKey:key_shop_pic];
        if (logoUrl)
        {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [self.shopLogoImageView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"showShopPicture : Error : %@", error.localizedDescription);
#endif
    }];
}

- (void)showShopReviews
{
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    
    [[APIManager sharedManager] showShopReview:[shopId doubleValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"Shop Reviews : %@", responseObject);
#endif
        self.shopReviews = [NSMutableArray arrayWithCapacity:0];
        
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            self.shopReviews = [NSMutableArray arrayWithArray:responseObject];
        }
        
        [self.shopReviewTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"Shop Reviews Error : %@", error.localizedDescription);
#endif
    }];
}

- (void)loadDealsOfShop {
    
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    
    [[APIManager sharedManager] getDealOfShop:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"Deal of Shop : %@", responseObject);
#endif
        self.dealInfosOfShop = [NSMutableArray arrayWithCapacity:0];
        
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            self.dealInfosOfShop = [NSMutableArray arrayWithArray:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"Deal of Shop Error : %@", error.localizedDescription);
#endif
    }];
}

- (IBAction)btnWriteReviewTapped:(UIButton *)sender {
    
    if (![[APIManager sharedManager] isUserLoggedIn]) {
        [[AlertManager sharedManager] showErrorAlert:@"Please login to write a review." onVC:self];
        return;
    }
    
    NSString* shopId = [self.shopInfo valueForKey:key_shop_id];
    [self performSegueWithIdentifier:Segue_ShowWriteReview sender:shopId];
}

- (IBAction)btnViewDealsTapped:(UIButton *)sender {
    
    if (self.dealInfosOfShop && self.dealInfosOfShop.count > 0) {
        NSMutableDictionary* dealInfo = [self.dealInfosOfShop firstObject];
        if (dealInfo && [dealInfo isKindOfClass:[NSDictionary class]]) {
            [self performSegueWithIdentifier:Segue_ShowDealsDetail sender:dealInfo];
            return;
        }
    }
    
    [[AlertManager sharedManager] showErrorAlert:@"No deals to show" onVC:self];
}

- (IBAction)btnFollowTapped:(UIButton *)sender
{
    if ([[APIManager sharedManager] getUserId] == 0) {
        [[AlertManager sharedManager] showErrorAlert:@"Please login to follow your favorite shops and be the first to know when they post a new deal." onVC:self];
        return;
    }
    
    NSString* shopId = [self.shopInfo objectForKey:key_shop_id];
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] shopFollow_Unfollow:shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"%@", responseObject);
#endif
        if ([[responseObject valueForKey:key_message] isEqualToString:key_FOLLOW]) {
            [[AlertManager sharedManager] showErrorAlert:@"Shop Followed Successfully." onVC:self];
            self.btnFollowState.selected = YES;
        }
        else {
            [[AlertManager sharedManager] showErrorAlert:@"Shop Unfollowed Successfully." onVC:self];
            self.btnFollowState.selected = NO;
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"Error : %@", error.localizedDescription);
#endif
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)btnGetDirectionTapped:(id)sender
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake([[self.shopInfo valueForKey:key_shop_lat] doubleValue], [[self.shopInfo valueForKey:key_shop_long] doubleValue]);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:[self.shopInfo valueForKey:key_shop_name]];
        // Pass the map item to the Maps app
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}


- (IBAction)unwindToShopDetailVC:(UIStoryboardSegue*)segue {
    
    [self.shopReviewTableView setContentOffset:CGPointMake(0.f, self.shopInfoWrapper.frame.origin.y + self.shopInfoWrapper.frame.size.height - self.navigationController.navigationBar.frame.size.height - 35.f - 30.f) animated:YES];
    
    // load shop reviews
    [self performSelectorOnMainThread:@selector(showShopReviews) withObject:nil waitUntilDone:NO];
}


@end
