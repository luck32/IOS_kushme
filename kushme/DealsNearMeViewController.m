//
//  DealsNearMeViewController.m
//  kushme
//
//  Created by Yanny on 5/17/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "DealsNearMeViewController.h"
#import "DealsNearMeCell.h"
#import "DealsDetailViewController.h"

@interface DealsNearMeViewController ()

@end

@implementation DealsNearMeViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_LocationAuthorizationStatusChanged object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"DEALS";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startToLoadData:) name:Notification_LocationAuthorizationStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNearMeDeals) name:Notification_UserLocationUpdated object:nil];
    
    [self checkLocationService];
    
//    [self loadNearMeDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if ([tableView isEqual:self.nearMeTableView])
        return [self.nearMeResults count];
    else if ([tableView isEqual:self.favoriteTableView])
        return [self.favoriteResults count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealsNearMeCell *cell = (DealsNearMeCell*)[tableView dequeueReusableCellWithIdentifier:@"DealsNearMeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSMutableDictionary* dealInfo = nil;
    if ([tableView isEqual:self.nearMeTableView]) {
        dealInfo = [NSMutableDictionary dictionaryWithDictionary:[self.nearMeResults objectAtIndex:indexPath.row]];
    }
    else {
        dealInfo = [NSMutableDictionary dictionaryWithDictionary:[self.favoriteResults objectAtIndex:indexPath.row]];
    }
    
    if (dealInfo) {
        // set logos
        
        __block NSString* logoUrl = [dealInfo objectForKey:key_deal_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [cell.dealLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        
        logoUrl = [dealInfo objectForKey:key_shop_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [cell.shopLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        else {
            NSString* shopId = [dealInfo objectForKey:key_shop_id];
            
            [[APIManager sharedManager] showShopPicture:shopId picCount:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
#if DEBUG
                NSLog(@"showShopPicture : %@", responseObject);
#endif
                logoUrl = [[responseObject firstObject] objectForKey:key_shop_pic];
                if (logoUrl) {
                    [dealInfo setValue:logoUrl forKey:key_shop_pic];
                    
                    if ([tableView isEqual:self.nearMeTableView]) {
                        [self.nearMeResults replaceObjectAtIndex:indexPath.row withObject:dealInfo];
                    }
                    else {
                        [self.favoriteResults replaceObjectAtIndex:indexPath.row withObject:dealInfo];
                    }
                    
                    logoUrl = logoUrl.stringByRemovingPercentEncoding;
                    [cell.shopLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
#if DEBUG
                NSLog(@"showShopPicture : Error : %@", error.localizedDescription);
#endif
            }];
        }
        
        NSString* shopName = [dealInfo objectForKey:key_shop_name];
        cell.dealTitleLabel.text = [UtilManager validateResponse:shopName];
        
        NSString* dealName = [dealInfo objectForKey:key_deal_name];
        cell.dealDescLabel.text = [UtilManager validateResponse:dealName];
        
        NSString* shopCity = [dealInfo objectForKey:key_shop_city];
//        cell.locationLabel.text = [NSString stringWithFormat:@"%d miles", [[dealDict objectForKey:key_distance] intValue]];
        cell.locationLabel.text = [UtilManager validateResponse:shopCity];
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

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowDealsDetail]) {
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        
        NSMutableDictionary* dealInfo = nil;
        if (self.view.tag == 0) {
            dealInfo = [NSMutableDictionary dictionaryWithDictionary:[self.nearMeResults objectAtIndex:indexPath.row]];
        }
        else {
            dealInfo = [NSMutableDictionary dictionaryWithDictionary:[self.favoriteResults objectAtIndex:indexPath.row]];
        }
        
        DealsDetailViewController* vc = (DealsDetailViewController*)segue.destinationViewController;
        vc.isSavedDeal = NO;
        vc.dealInfo = dealInfo;
    }
}


#pragma mark -
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:Segue_ShowDealsDetail sender:indexPath];
}

#pragma mark -
#pragma mark - Main methods

- (IBAction)tapTabButton:(UIButton*)sender {
    
    self.view.tag = sender.tag;
    
    self.nearMeBorderView.alpha = self.view.tag == 0;
    self.nearMeTableView.alpha = self.view.tag == 0;
    self.favoriteBorderView.alpha = self.view.tag == 1;
    self.favoriteTableView.alpha = self.view.tag == 1;
    
    if (self.view.tag == 1) {
        if ([[APIManager sharedManager] isUserLoggedIn]) {
            [self loadFavoriteDeals];
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Please login so you can receive special deals from your favorite shops" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            UIAlertAction* loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
            }];
            [alert addAction:loginAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if (self.view.tag == 0) {
        if (!self.nearMeResults || self.nearMeResults.count < 1) {
            [self loadNearMeDeals];
        }
    }
}

- (void)checkLocationService {
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusDenied) {
            [self loadWithDefaultLocation];
        }
        else {
            [[LocationManager sharedManager] initCurrentLocation];
            [SVProgressHUD showWithStatus:@"Location detection"];
            if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
                [self performSelector:@selector(loadWithDefaultLocation) withObject:nil afterDelay:5];
        }
    }
    else {
        [self loadWithDefaultLocation];
    }
}

- (void)startToLoadData:(NSNotification*)notif {
    
    CLAuthorizationStatus status = [notif.object intValue];
    if (status == kCLAuthorizationStatusNotDetermined)
        return;
    
    self.nearMeResults = nil;
    [self.nearMeTableView reloadData];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [SVProgressHUD showWithStatus:@"Location detection"];
        [self performSelector:@selector(loadWithDefaultLocation) withObject:nil afterDelay:5];
    }
    else {
        [self loadWithDefaultLocation];
    }
}

- (void)loadWithDefaultLocation {
    if ([self.nearMeResults count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Your location couldn’t be found. Using Long Beach, CA as your default" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [self loadNearMeDeals];
    }
}

- (void)loadFavoriteDeals {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getFavoriteDeals:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"loadFavoriteDeals : %@", responseObject);
#endif
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allKeys = [responseObject allKeys];
                if (allKeys) {
                    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
                        if (obj1.intValue > obj2.intValue)
                            return NSOrderedDescending;
                        return NSOrderedAscending;
                    }];
                }
                
                for (NSString* dealKey in allKeys) {
                    NSDictionary* dealDict = [responseObject objectForKey:dealKey];
                    if (dealDict && [dealDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:dealDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            if (searchResults && [searchResults count] > 0) {
                self.favoriteResults = [NSMutableArray arrayWithArray:searchResults];
                [self.favoriteTableView reloadData];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"No deals for you"];
                self.favoriteResults = nil;
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"loadFavoriteDeals : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}

- (void)loadNearMeDeals {
    
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];
    
    LocationManager* locationManager = [LocationManager sharedManager];
    if (!locationManager.userLocation)
        locationManager.userLocation = [[CLLocation alloc] initWithLatitude:33.768333 longitude:-118.195556];
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getNearMeDealsWithLatitude:locationManager.userLocation.coordinate.latitude longitude:locationManager.userLocation.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"loadNearMeDeals : %@", responseObject);
#endif
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allKeys = [responseObject allKeys];
                if (allKeys) {
                    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
                        if (obj1.intValue > obj2.intValue)
                            return NSOrderedDescending;
                        return NSOrderedAscending;
                    }];
                }
                
                for (NSString* dealKey in allKeys) {
                    NSDictionary* dealDict = [responseObject objectForKey:dealKey];
                    if (dealDict && [dealDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:dealDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            if (searchResults && searchResults.count > 0) {
                self.nearMeResults = [NSMutableArray arrayWithArray:searchResults];
                [self.nearMeTableView reloadData];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"No deals around you"];
                self.nearMeResults = nil;
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"loadNearMeDeals : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}


@end
