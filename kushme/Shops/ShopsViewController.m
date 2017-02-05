//
//  ShopsViewController.m
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopsViewController.h"
#import "ShopsCell.h"
#import "ShopMapViewController.h"
#import "ShopDetailViewController.h"


@interface ShopsViewController () {
    
    NSArray*                    searchResultPlaces;
    PlacesAutocompleteQuery*    searchQuery;
    
    BOOL                        shouldBeginEditing;
}

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutlet UIButton* mapButton;
@property (strong, nonatomic) IBOutlet UIButton* cancelButton;
@property (strong, nonatomic) IBOutlet UIButton* searchButton;


// GoogleSearch
@property (strong, nonatomic) IBOutlet KushmeSearchBar* searchBar;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSMutableArray* searchPlaces;

@end

@implementation ShopsViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_LocationAuthorizationStatusChanged object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startToLoadData:) name:Notification_LocationAuthorizationStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShopList) name:Notification_UserLocationUpdated object:nil];
    
    searchQuery = [[PlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.f;
    shouldBeginEditing = YES;
    
    [self expandSearchWrapper:NO];
    [self checkLocationService];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar setBackgroundImage:[[UIImage alloc] init]];
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
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [searchResultPlaces count];
    }
    return [self.searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
        return 44.f;
    return 100.f;
}

- (PlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        static NSString* cellIdentifier = @"PlacesAutocompleteCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
        
        return cell;
    }
    
    ShopsCell *cell = (ShopsCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopsCell" forIndexPath:indexPath];
    NSDictionary* shopDict = [self.searchResults objectAtIndex:indexPath.row];
    if (shopDict) {
        // set logo
        NSString* logoUrl = [shopDict objectForKey:key_shop_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [cell.shopLogoView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }   
        
        NSString* shopName = [shopDict objectForKey:key_shop_name];
        if ([cell isMultilineShopName:shopName])
            cell.shopNameLabel.text = shopName;
        else
            cell.shopNameLabel.text = [shopName stringByAppendingString:@"\n"];
        
        cell.shopDistanceLabel.text = [NSString stringWithFormat:@"%@ miles", [shopDict objectForKey:key_distance]];
        cell.shopAddressLabel.text = [shopDict objectForKey:key_shop_address];
        [cell setRate:[[shopDict objectForKey:key_shop_rating] intValue]];
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
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resignInputFields];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        PlacesAutocompletePlace* place = [self placeAtIndexPath:indexPath];
        if (place) {
            [SVProgressHUD show];
            [place resolveToPlaceDictionary:^(NSDictionary *placeDictionary, NSError *error) {
                [SVProgressHUD dismiss];
                self.location = nil;
                if (error) {
                    [[AlertManager sharedManager] showErrorAlert:@"Could not select the Place" onVC:self];
                }
                else if (placeDictionary) {
                    NSDictionary* locationDict = [[placeDictionary objectForKey:key_geometry] objectForKey:key_location];
                    
                    [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
                    [self dismissSearchControllerWhileStayingActive];
                    [self.searchDisplayController setActive:NO];
                    
                    self.locationField.text = place.name;
//                    self.location = placemark.location;
                    self.location = [[CLLocation alloc] initWithLatitude:[locationDict[key_lat] doubleValue] longitude:[locationDict[key_lng] doubleValue]];
                }
            }];
//            [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
//                [SVProgressHUD dismiss];
//                self.location = nil;
//                if (error) {
//                    [[AlertManager sharedManager] showErrorAlert:@"Could not select the Place" onVC:self];
//                }
//                else if (placemark) {
//                    
//                    NSLog(@"Place = %@", placemark.location);
//                    
//                    [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
//                    [self dismissSearchControllerWhileStayingActive];
//                    [self.searchDisplayController setActive:NO];
//                    
//                    self.locationField.text = place.name;
//                    self.location = placemark.location;
//                }
//            }];
        }
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:Segue_ShowShopDetail sender:indexPath];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowShopMap]) {
        
        ShopMapViewController* mapVC = (ShopMapViewController*)segue.destinationViewController;
        if (mapVC && [mapVC isKindOfClass:[ShopMapViewController class]]) {
            mapVC.shopList = self.shopList;
            mapVC.searchResults = [NSMutableArray arrayWithArray:mapVC.shopList];
        }
    }
    else if ([segue.identifier isEqualToString:Segue_ShowShopDetail]) {
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        if (self.searchResults && self.searchResults.count > indexPath.row) {
            NSDictionary* shopInfo = [self.searchResults objectAtIndex:indexPath.row];
            if (shopInfo) {
                ShopDetailViewController* vc = (ShopDetailViewController*)segue.destinationViewController;
                vc.shopInfo = [NSMutableDictionary dictionaryWithDictionary:shopInfo];
            }
        }
    }
}


#pragma mark -
#pragma mark - Main methods

- (IBAction)tapBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapCancelButton:(id)sender {
    
    [self cancelToSearchShop];
}

- (IBAction)tapMapButton:(id)sender {
    
}

- (IBAction)tapSearchButton:(id)sender {
    
    [self searchShopList];
}

- (IBAction)tapShopSearchButton:(UIButton*)sender {
    
    self.shopNameField.text = @"";
    self.strainsField.text = @"";
    self.locationField.text = @"";
    
    [self expandSearchWrapper:YES];
}

- (void)expandSearchWrapper:(BOOL)expand {
    
    CGFloat searchViewHeight = expand ? 167.f : 77.f;
    
    // Set Constraints
    NSArray* constraints = self.searchView.constraints;
    for (NSLayoutConstraint* constraint in constraints)
    {
        // ContainerView constraint
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            if ([constraint.firstItem isEqual:self.self.searchView]) {
                constraint.constant = searchViewHeight;
            }
        }
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.searchView.frame;
        frame.size.height = searchViewHeight;
        self.searchView.frame = frame;
        
        self.titleLabel.text = expand ? @"DISPENSARY" : @"SHOPS";
        
        self.backButton.alpha = !expand;
        self.mapButton.alpha = !expand;
        self.cancelButton.alpha = expand;
        self.searchButton.alpha = expand;
        
        self.shopSearchButton.alpha = !expand;
        self.shopNameField.alpha = expand;
        self.strainsField.alpha = expand;
        self.locationField.alpha = expand;
        
        self.overlayView.alpha = expand ? 0.33f : 0.f;
        
    } completion:^(BOOL finished) {
        
    }];
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
    
    self.shopList = nil;
    [self.shopsTableView reloadData];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [SVProgressHUD showWithStatus:@"Location detection"];
        [self performSelector:@selector(loadWithDefaultLocation) withObject:nil afterDelay:5];
    }
    else {
        [self loadWithDefaultLocation];
    }
}

- (void)loadWithDefaultLocation {
    if ([self.shopList count] == 0) {
        if(![[LocationManager sharedManager] userLocation])
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Your location couldn’t be found. Using Long Beach, CA as your default" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [self loadShopList];
    }
}

- (void)loadShopList {
    
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];
    
    LocationManager* locationManager = [LocationManager sharedManager];
    if (!locationManager.userLocation)
        locationManager.userLocation = [[CLLocation alloc] initWithLatitude:33.768333 longitude:-118.195556];
    
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] shopListWithLatitude:locationManager.userLocation.coordinate.latitude longitude:locationManager.userLocation.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"ShopList : %@", responseObject);
#endif
        self.shopList = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray* newShops = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [newShops addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [newShops addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedResults = [UtilManager sortShopList:newShops];
            if (sortedResults && sortedResults.count > 0) {
                self.shopList = [NSMutableArray arrayWithArray:sortedResults];
            }
            
            self.searchResults = [NSMutableArray arrayWithArray:self.shopList];
            
            [self.shopsTableView reloadData];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"ShopList : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
    }];
}

- (void)searchShopList {
    
    [self resignInputFields];
    
    NSString* shopName = self.shopNameField.text;
    NSString* menuName = self.strainsField.text;
    NSString* location = self.locationField.text;
    
    if (!shopName)
        shopName = @"";
    if (!menuName)
        menuName = @"";
    if (!location)
        location = @"";
    
//    LocationManager* locationManager = [LocationManager sharedManager];
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] searchShopListWithName:shopName menuName:menuName location:location latitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"SearchShopList : %@", responseObject);
#endif
        self.searchResults = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray* newShops = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [newShops addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [newShops addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedSearchResults = [UtilManager sortShopList:newShops];
            if (sortedSearchResults && sortedSearchResults.count > 0) {
                self.searchResults = [NSMutableArray arrayWithArray:sortedSearchResults];
            }
            
            [self.shopsTableView reloadData];
            
            [self cancelToSearchShop];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"SearchShopList : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
    }];
    
}

- (IBAction)cancelToSearchShop {
    
    [self resignInputFields];
    [self expandSearchWrapper:NO];
    
//    self.searchResults = [NSMutableArray arrayWithArray:self.shopList];
    [self.shopsTableView reloadData];
}

- (IBAction)resignInputFields {
    
    [self.shopNameField resignFirstResponder];
    [self.strainsField resignFirstResponder];
    [self.locationField resignFirstResponder];
    
    [self dismissSearchControllerWhileStayingActive];
    [self.searchDisplayController setActive:NO];
}


- (IBAction)unwindToShopsVC:(UIStoryboardSegue*)segue {
    
}


#pragma mark -
#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.locationField]) {
        [self.searchBar becomeFirstResponder];
    }
    else {
        [self dismissSearchControllerWhileStayingActive];
        [self.searchDisplayController setActive:NO];
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    
    //    searchQuery.location = self.mapView.userLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
        }
        else {
            searchResultPlaces = [NSArray arrayWithArray:places];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)clearRecentSearches {
    //    [self.historyTableView reloadData];
}

- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    [UIView animateWithDuration:0.3f animations:^{
        self.searchBar.alpha = 0.f;
        self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        // Animate in the table view.
        
        [self.view bringSubviewToFront:self.searchBar];
        
        [UIView animateWithDuration:0.3f animations:^{
            searchBar.alpha = 1.f;
            self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissSearchControllerWhileStayingActive];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"searchDisplayControllerWillBeginSearch");
    
    [UIView animateWithDuration:0.05f animations:^{
        CGRect frame = self.searchBar.frame;
        frame.origin.y = 20.f;
        self.searchBar.frame = frame;
    }];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"searchDisplayControllerWillEndSearch");
    
    [UIView animateWithDuration:0.05f animations:^{
        CGRect frame = self.searchBar.frame;
        frame.origin.y = 0.f;
        self.searchBar.frame = frame;
    }];
}


@end
