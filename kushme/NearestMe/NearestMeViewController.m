//
//  NearestMeViewController.m
//  kushme
//
//  Created by Yanny on 5/16/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "NearestMeViewController.h"
#import "ShopsCell.h"
#import "ShopMapViewController.h"
#import "ShopDetailViewController.h"
#import "LoginViewController.h"

@interface NearestMeViewController () <LoginDelegate> {
    
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

@implementation NearestMeViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startToLoadData:) name:Notification_LocationAuthorizationStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNearMeShops) name:Notification_UserLocationUpdated object:nil];
    
    searchQuery = [[PlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.f;
    shouldBeginEditing = YES;
    
    [self expandSearchWrapper:NO];
    [self checkLocationService];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.view.tag == 1) {
        if ([[APIManager sharedManager] isUserLoggedIn]) {
            [self loadFavoriteShops];
        }
    }
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
    else {
        if ([tableView isEqual:self.nearestMeTableView])
            return [self.nearestMeResults count];
        else if ([tableView isEqual:self.favoriteTableView])
            return [self.favoriteResults count];
    }
    
    return 0;
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
    NSDictionary* shopDict = nil;
    if ([tableView isEqual:self.nearestMeTableView]) {
        shopDict = [self.nearestMeResults objectAtIndex:indexPath.row];
    }
    else {
        shopDict = [self.favoriteResults objectAtIndex:indexPath.row];
    }
    
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
        
        cell.shopDistanceLabel.text = [NSString stringWithFormat:@"%d miles", [[shopDict objectForKey:key_distance] intValue]];
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
                    self.location = [[CLLocation alloc] initWithLatitude:[locationDict[key_lat] doubleValue] longitude:[locationDict[key_lng] doubleValue]];
                }
            }];
        }
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:Segue_ShowShopDetail sender:indexPath];
    }
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowShopMap]) {
        
        ShopMapViewController* mapVC = (ShopMapViewController*)segue.destinationViewController;
        if (mapVC && [mapVC isKindOfClass:[ShopMapViewController class]]) {
            
            if (self.view.tag == 0) {
                mapVC.shopList = self.nearestMeResults;
            }
            else {
                mapVC.shopList = self.favoriteResults;
            }
            mapVC.searchResults = [NSMutableArray arrayWithArray:mapVC.shopList];
        }
    }
    else if ([segue.identifier isEqualToString:Segue_ShowShopDetail]) {
        
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        
        if (self.view.tag == 0) {
            if (self.nearestMeResults && self.nearestMeResults.count > indexPath.row) {
                NSDictionary* shopInfo = [self.nearestMeResults objectAtIndex:indexPath.row];
                if (shopInfo) {
                    ShopDetailViewController* vc = (ShopDetailViewController*)segue.destinationViewController;
                    vc.shopInfo = [NSMutableDictionary dictionaryWithDictionary:shopInfo];
                }
            }
        }
        else {
            if (self.favoriteResults && self.favoriteResults.count > indexPath.row) {
                NSDictionary* shopInfo = [self.favoriteResults objectAtIndex:indexPath.row];
                if (shopInfo) {
                    ShopDetailViewController* vc = (ShopDetailViewController*)segue.destinationViewController;
                    vc.shopInfo = [NSMutableDictionary dictionaryWithDictionary:shopInfo];
                }
            }
        }
    }
    else if ([segue.identifier isEqualToString:Segue_ShowLogin]) {
        LoginViewController* loginVC = (LoginViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        loginVC.loginDelegate = self;
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
    
    if (self.view.tag == 0)
        [self searchNearMeShops];
    else
        [self searchFavoriteShops];
}

- (IBAction)tapTabButton:(UIButton*)sender {
    
    self.view.tag = sender.tag;
    
    self.nearestMeBorderView.alpha = self.view.tag == 0;
    self.nearestMeTableView.alpha = self.view.tag == 0;
    self.favoriteBorderView.alpha = self.view.tag == 1;
    self.favoriteTableView.alpha = self.view.tag == 1;
    
    if (self.view.tag == 0) {
        if (!self.nearestMeResults || self.nearestMeResults.count < 1) {
            [self loadNearMeShops];
        }
    }
    else if (self.view.tag == 1) {
        if ([[APIManager sharedManager] isUserLoggedIn]) {
            [self loadFavoriteShops];
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Please login so we can display your favorite shops." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            UIAlertAction* loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
            }];
            [alert addAction:loginAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (IBAction)tapShopSearchButton:(UIButton*)sender {
    
    self.shopNameField.text = @"";
    self.strainsField.text = @"";
    self.locationField.text = @"";
    
    [self expandSearchWrapper:YES];
}

- (void)expandSearchWrapper:(BOOL)expand {
    
    CGFloat searchViewHeight = expand ? 167.f : 44.f;
    
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
    
    self.nearestMeResults = nil;
    [self.nearestMeTableView reloadData];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [SVProgressHUD showWithStatus:@"Location detection"];
        [self performSelector:@selector(loadWithDefaultLocation) withObject:nil afterDelay:5];
    }
    else {
        [self loadWithDefaultLocation];
    }
}

- (void)loadWithDefaultLocation {
    if ([self.nearestMeResults count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Your location couldn’t be found. Using Long Beach, CA as your default" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [self loadNearMeShops];
    }
}

- (void)loadFavoriteShops {
    
    LocationManager* locationManager = [LocationManager sharedManager];
    if (!locationManager.userLocation)
        locationManager.userLocation = [[CLLocation alloc] initWithLatitude:33.768333 longitude:-118.195556];
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] shopListFavoriteWithLatitude:locationManager.userLocation.coordinate.latitude longitude:locationManager.userLocation.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"loadFavoriteShops : %@", responseObject);
#endif
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedSearchResults = [UtilManager sortShopList:searchResults];
            if (sortedSearchResults && [sortedSearchResults count] > 0) {
                self.favoriteResults = [NSMutableArray arrayWithArray:sortedSearchResults];
                [self.favoriteTableView reloadData];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"You have no followed shops"];
                self.favoriteResults = nil;
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"loadFavoriteShops : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}

- (void)loadNearMeShops {
    
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];
    
    LocationManager* locationManager = [LocationManager sharedManager];
    if (!locationManager.userLocation)
        locationManager.userLocation = [[CLLocation alloc] initWithLatitude:33.768333 longitude:-118.195556];
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] shopListNearMeWithLatitude:locationManager.userLocation.coordinate.latitude longitude:locationManager.userLocation.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"loadNearMeShops : %@", responseObject);
#endif
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedSearchResults = [UtilManager sortShopList:searchResults];
            if (sortedSearchResults && sortedSearchResults.count > 0) {
                self.nearestMeResults = [NSMutableArray arrayWithArray:sortedSearchResults];
                [self.nearestMeTableView reloadData];
            }
            else {
                [SVProgressHUD showInfoWithStatus:@"No shops around you"];
                self.nearestMeResults = nil;
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"loadNearMeShops : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
}

- (void)searchNearMeShops {
    
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
        NSLog(@"searchNearMeShops : %@", responseObject);
#endif
        
        self.nearestMeResults = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedSearchResults = [UtilManager sortShopList:searchResults];
            if (sortedSearchResults && [sortedSearchResults count] > 0) {
                self.nearestMeResults = [NSMutableArray arrayWithArray:sortedSearchResults];
            }
        }
        
        [self.nearestMeTableView reloadData];
        [self cancelToSearchShop];
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"searchNearMeShops : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
    
}

- (void)searchFavoriteShops {
    
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
        NSLog(@"searchFavoriteShops : %@", responseObject);
#endif
        
        self.favoriteResults = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray* searchResults = [NSMutableArray arrayWithCapacity:0];
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray* allValues = [responseObject allValues];
                for (NSDictionary* shopDict in allValues) {
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            NSArray* sortedSearchResults = [UtilManager sortShopList:searchResults];
            if (sortedSearchResults && sortedSearchResults.count > 0) {
                self.favoriteResults = [NSMutableArray arrayWithArray:sortedSearchResults];
            }
        }
        
        [self.favoriteTableView reloadData];
        [self cancelToSearchShop];
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"searchFavoriteShops : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
        [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
    }];
    
}

- (IBAction)cancelToSearchShop {
    
    [self resignInputFields];
    [self expandSearchWrapper:NO];
    
//    self.searchResults = [NSMutableArray arrayWithArray:self.shopList];
    
    if (self.view.tag == 0)
        [self.nearestMeTableView reloadData];
    else
        [self.favoriteTableView reloadData];
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
#pragma mark - Login delegate

- (void)kushmeDidLogin {
    
    if (!self.favoriteResults || self.favoriteResults.count < 1) {
        [self loadFavoriteShops];
    }
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

