//
//  ShopMapViewController.m
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopMapViewController.h"
#import "ShopAnnotation.h"
#import "ShopDetailViewController.h"

@interface ShopMapViewController () {
    
    NSArray*                    searchResultPlaces;
    PlacesAutocompleteQuery*    searchQuery;
    
    BOOL                        shouldBeginEditing;
}

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutlet UIButton* shopListButton;
@property (strong, nonatomic) IBOutlet UIButton* cancelButton;
@property (strong, nonatomic) IBOutlet UIButton* searchButton;


// GoogleSearch
@property (strong, nonatomic) IBOutlet KushmeSearchBar* searchBar;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSMutableArray* searchPlaces;


@end

@implementation ShopMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchQuery = [[PlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.f;
    shouldBeginEditing = YES;
    
    [self expandSearchWrapper:NO];
    
    // load shop list
    [self showShopAnnotations];
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
    return [searchResultPlaces count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (PlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"PlacesAutocompleteCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    return cell;
}


#pragma mark -
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resignInputFields];
    
    PlacesAutocompletePlace* place = [self placeAtIndexPath:indexPath];
    if (place) {
        [SVProgressHUD show];
//        [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
//            [SVProgressHUD dismiss];
//            self.location = nil;
//            if (error) {
//                [[AlertManager sharedManager] showErrorAlert:@"Could not select the Place" onVC:self];
//            }
//            else if (placemark) {
//                
//                NSLog(@"Place = %@", placemark.location);
//                
//                [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
//                [self dismissSearchControllerWhileStayingActive];
//                [self.searchDisplayController setActive:NO];
//                
//                self.locationField.text = place.name;
//                self.location = placemark.location;
//            }
//        }];
        
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowShopDetail]) {
        NSDictionary* shopInfo = sender;
        if (shopInfo) {
            ShopDetailViewController* vc = (ShopDetailViewController*)segue.destinationViewController;
            vc.shopInfo = [NSMutableDictionary dictionaryWithDictionary:shopInfo];
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
        
        self.titleLabel.text = expand ? @"DISPENSARY" : @"MAP";
        
        self.backButton.alpha = !expand;
        self.shopListButton.alpha = !expand;
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

- (void)showShopAnnotations
{
    LocationManager* locationManager = [LocationManager sharedManager];
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(locationManager.userLocation.coordinate.latitude,
                                                                   locationManager.userLocation.coordinate.longitude);
    MKCoordinateRegion adjustedRegion = [self.shopMapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
    adjustedRegion.span.latitudeDelta = .002;
    adjustedRegion.span.longitudeDelta = .002;
    
    [self.shopMapView setRegion:adjustedRegion animated:YES];
    
    
    NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [self.searchResults count]; i ++)
    {
        NSDictionary* shopInfo = [self.searchResults objectAtIndex:i];
        
        ShopAnnotation* annotation = [[ShopAnnotation alloc] initWithShopInfo:shopInfo];
        annotation.tag = i;
        
        [annotations addObject:annotation];
        
        
        
        //        AppDelegate* appDelegate = [AppDelegate appDelegate];
        //
        //        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(appDelegate.userLocation.coordinate.latitude,
        //                                                                       appDelegate.userLocation.coordinate.longitude);
        //        MKCoordinateRegion adjustedRegion = [self.shopMapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
        //        adjustedRegion.span.latitudeDelta = .005;
        //        adjustedRegion.span.longitudeDelta = .005;
        
        CLLocationDegrees latitude = [[shopInfo objectForKey:key_shop_lat] doubleValue];
        CLLocationDegrees longitude = [[shopInfo objectForKey:key_shop_long] doubleValue];
        
        CLLocation* shopLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
#ifndef __IPHONE_3_0
        CLLocationDistance meters = [locationManager.userLocation getDistanceFrom:(const CLLocation)activityLocation];
#else
        CLLocationDistance meters = [locationManager.userLocation distanceFromLocation:(const CLLocation *)shopLocation];
#endif
        if (meters > 9000000)
            meters = 9000000;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationManager.userLocation.coordinate, 2 * meters, meters);
        MKCoordinateRegion adjustedRegion = [self.shopMapView regionThatFits:region];
        
        [self.shopMapView setRegion:adjustedRegion animated:NO];
    }
    
    [self.shopMapView removeAnnotations:self.shopMapView.annotations];
    [self.shopMapView addAnnotations:annotations];
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
                NSArray* allKeys = [responseObject allKeys];
                if (allKeys) {
                    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
                        if (obj1.intValue > obj2.intValue)
                            return NSOrderedDescending;
                        return NSOrderedAscending;
                    }];
                }
                
                for (NSString* shopKey in allKeys) {
                    NSDictionary* shopDict = [responseObject objectForKey:shopKey];
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [newShops addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [newShops addObjectsFromArray:responseObject];
            }
            
            if (newShops && newShops.count > 0) {
                self.searchResults = [NSMutableArray arrayWithArray:newShops];
            }
            
            [self showShopAnnotations];
            
            [self resignInputFields];
            [self expandSearchWrapper:NO];
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
    [self showShopAnnotations];
}

- (IBAction)resignInputFields {
    
    [self.shopNameField resignFirstResponder];
    [self.strainsField resignFirstResponder];
    [self.locationField resignFirstResponder];
    
    [self dismissSearchControllerWhileStayingActive];
    [self.searchDisplayController setActive:NO];
}


#pragma mark -
#pragma mark - MKMapView delegate

- (void)zoomMapView:(CLLocationCoordinate2D)center
{
    //    [AppDelegate appDelegate].userLocation = self.mapsView.userLocation.location;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005f, 0.005f);
    //You can set span for how much Zoom to be display like below
    //    span.latitudeDelta = .005;
    //    span.longitudeDelta = .005;
    
    //set Region to be display on MKMapView
    MKCoordinateRegion cordinateRegion = MKCoordinateRegionMake(center, span);
    //    cordinateRegion.center = center;
    //
    //    //latAndLongLocation coordinates should be your current location to be display
    //    cordinateRegion.span = span;
    
    //set That Region mapView
    [self.shopMapView setRegion:cordinateRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        [self zoomMapView:annotation.coordinate];
        
        [LocationManager sharedManager].userLocation = mapView.userLocation.location;
        
        [mapView setCenterCoordinate:annotation.coordinate animated:YES];
        
//        [[AppDelegate appDelegate] didUpdateUserLocation:self.mapsView.userLocation.location];
        
        return nil;
    }
    //    else if (annotation == self.calloutAnnotation)
    //    {
    //        NSString* wuChuCalloutAnnotationIdentifier = @"WuChuCalloutAnnotation";
    //        ShopAnnotationView* annotationView = (ShopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:wuChuCalloutAnnotationIdentifier];
    //        if (!annotationView) {
    //            annotationView = [[ShopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:wuChuCalloutAnnotationIdentifier];
    //
    //            annotationView.contentHeight = 234.f;
    //            UIImage *asynchronyLogo = [UIImage imageNamed:@"background_popup_dialog.png"];
    //            UIImageView *asynchronyLogoView = [[UIImageView alloc] initWithImage:asynchronyLogo];
    //            asynchronyLogoView.frame = CGRectMake(5, 2, asynchronyLogoView.frame.size.width, asynchronyLogoView.frame.size.height);
    //            [annotationView.contentView addSubview:asynchronyLogoView];
    //        }
    //        annotationView.parentAnnotationView = self.selectedAnnotationView;
    //        annotationView.mapView = mapView;
    //
    //        return annotationView;
    //    }
    else if ([annotation isKindOfClass:[ShopAnnotation class]]) {
        
        ShopAnnotation* shopAnnotation = (ShopAnnotation*)annotation;
        NSString* AnnotationViewIdentifier = [NSString stringWithFormat:@"AnnotationViewIdentifier-%d", shopAnnotation.tag];
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewIdentifier];
        if (!annotationView) {
            CGRect annotationViewFrame = CGRectMake(0.f, 0.f, 15.f, 19.f);
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewIdentifier];
            annotationView.frame = annotationViewFrame;
            annotationView.opaque = NO;
            
            UIImage* annotationImage = [UIImage imageNamed:@"icon_shop_annotation"];
            UIImageView* photoView = [[UIImageView alloc] initWithImage:annotationImage];
            
            [annotationView addSubview:photoView];
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        annotationView.annotation = shopAnnotation;
        
        NSString* logoUrl = [shopAnnotation.shopInfo objectForKey:key_shop_pic];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            
            UIImageView* logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
            [logoView setImageWithURL:[NSURL URLWithString:logoUrl]];
            annotationView.leftCalloutAccessoryView = logoView;
        }
        
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self resignInputFields];
    
    ShopAnnotation* shopAnnotation = (ShopAnnotation*)view.annotation;
    if (shopAnnotation && shopAnnotation.shopInfo)
        [self performSegueWithIdentifier:Segue_ShowShopDetail sender:shopAnnotation.shopInfo];
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
