//
//  PlacesAutocompleteVC.m
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import "PlacesAutocompleteVC.h"
#import "PlacesAutocompleteQuery.h"
#import "PlacesAutocompletePlace.h"
//#import "AppDelegate.h"
//#import "AddEventVC.h"


//@implementation SearchDisplayController
//
//// set searchbar not to be animated
//- (void)setActive:(BOOL)visible animated:(BOOL)animated
//{
//    [super setActive:visible animated:animated];
//    
////    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//@end


@interface PlacesAutocompleteVC ()

@end

@implementation PlacesAutocompleteVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchQuery = [[PlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.0;
    shouldBeginEditing = YES;
    
    self.searchDisplayController.searchBar.placeholder = @"Search or Address";
    
    UIImageView* googleLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"google-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:googleLogoView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [searchResultPlaces count];
    
    return rowCount;
}

- (PlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"PlacesAutocompleteCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
        cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)clearRecentSearches
{
//    [self.historyTableView reloadData];
}

- (void)dismissSearchControllerWhileStayingActive
{
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.searchBar.alpha = 0.f;
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        PlacesAutocompletePlace* place = [self placeAtIndexPath:indexPath];
        [place resolveToPlacemark:^(CLPlacemark* placemark, NSString* address, NSError* error) {
            if (error) {
                [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:nil];
            } else if (placemark) {
                
//                NSString* placeId = place.placeId;
//                NSDictionary* placeDict = place.placeDict;
                
                [self dismissSearchControllerWhileStayingActive];
                [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
                
                [self.navigationController popViewControllerAnimated:YES];
                
//                if (self.parentVC && [self.parentVC respondsToSelector:@selector(didSelectLocation:placeId:place:latitude:longitude:)])
//                    [self.parentVC didSelectLocation:address placeId:place.placeId place:placeDict latitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
                
                if (_delegate && [_delegate respondsToSelector:@selector(didSelectLocation:latitude:longitude:)])
                    [_delegate didSelectLocation:address latitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
            }
        }];
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString
{
//    searchQuery.location = self.mapView.userLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:nil];
        } else {
            searchResultPlaces = [NSArray arrayWithArray:places];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        
        searchBar.alpha = 1.f;
        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}



- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillBeginSearch");
    
    [UIView animateWithDuration:0.05f animations:^{
        
        CGRect frame = self.searchBar.frame;
        frame.origin.y = 20.f;
        self.searchBar.frame = frame;
        
//        frame = self.historyTableView.frame;
//        frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
//        self.historyTableView.frame = frame;
    }];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"searchDisplayControllerWillEndSearch");
    
    [UIView animateWithDuration:0.05f animations:^{
        
        CGRect frame = self.searchBar.frame;
        frame.origin.y = 0.f;
        self.searchBar.frame = frame;
        
//        frame = self.historyTableView.frame;
//        frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
//        self.historyTableView.frame = frame;
    }];
}

@end
