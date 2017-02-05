//
//  checkInViewController.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "checkInViewController.h"
#import "APIManager.h"
#import "LocationManager.h"
#import "ShopTableViewCell.h"
#import "ShopDetailViewController.h"

#define CODE_LOGIN_MESSAGE @"Please login to get your own cool code"
#define CHECKIN_LOGIN_MESSAGE @"Please login to get check-in feature"

@interface checkInViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchButtonPage;
@property (nonatomic, strong) NSArray *shops;
@property int selectedShopId;

-(IBAction)pageSwitchAction:(id)sender;

@end

@implementation checkInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadData)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pageSwitchAction:nil];
    [self loadData];
}

-(void)loadData {
    self.shops = nil;
    [self.tableView reloadData];
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShopList) name:Notification_UserLocationUpdated object:nil];
        
        [[LocationManager sharedManager] initCurrentLocation];
        [SVProgressHUD showWithStatus:@"Location detection"];
        [self performSelector:@selector(loadWithDefaultLocation) withObject:nil afterDelay:5];
    }
    else {
        [self loadWithDefaultLocation];
    }
}

-(void)loadWithDefaultLocation {
    if([self.shops count] == 0) {
        if(![[LocationManager sharedManager] userLocation])
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Your location couldn’t be found. Using Long Beach, CA as your default" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [self loadShopList];
    }
}

-(IBAction)pageSwitchAction:(id)sender {
    self.tableView.separatorStyle = (self.switchButtonPage.selectedSegmentIndex == 1)?UITableViewCellSeparatorStyleNone:UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    if(self.switchButtonPage.selectedSegmentIndex == 1 && ![[APIManager sharedManager] isUserLoggedIn]) {
        [[[UIAlertView alloc] initWithTitle:nil message:CODE_LOGIN_MESSAGE delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)loadShopList {
    CLLocation *loc = [[LocationManager sharedManager] userLocation];
    if(!loc)
        loc = [[CLLocation alloc] initWithLatitude:33.768333 longitude:-118.195556];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UserLocationUpdated object:nil];

    [self.refreshControl endRefreshing];

    [SVProgressHUD showWithStatus:@"Loading shops"];
    [[APIManager sharedManager] shopListWithLatitude:loc.coordinate.latitude
                                           longitude:loc.coordinate.longitude
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 if([responseObject isKindOfClass:[NSArray class]]) {
                                                     self.shops = [NSArray arrayWithArray:responseObject];
                                                     [self.tableView reloadData];
                                                 }
                                                 else {
                                                     [SVProgressHUD showErrorWithStatus:@"Unexpected API return"];
                                                 }
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [SVProgressHUD dismiss];
                                                 [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
                                             }];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.switchButtonPage.selectedSegmentIndex == 0)
        return [self.shops count];
    else
        return [[APIManager sharedManager] isUserLoggedIn]?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.switchButtonPage.selectedSegmentIndex == 0)
        return 88;
    else
        return tableView.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.switchButtonPage.selectedSegmentIndex == 0) {
        ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
        [cell setCellData:self.shops[indexPath.section]];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCodeCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.switchButtonPage.selectedSegmentIndex == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.selectedShopId = [self.shops[indexPath.section][key_shopid] intValue];
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Want to checkin?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Checkin", nil] show];
    }
}


#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.message isEqualToString:CODE_LOGIN_MESSAGE] && buttonIndex == 1) {
        [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
        return;
    }
    if(buttonIndex == 1) {
        if(![[APIManager sharedManager] isUserLoggedIn]) {
            [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
            [[[UIAlertView alloc] initWithTitle:nil message:CHECKIN_LOGIN_MESSAGE delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        else {
            [SVProgressHUD show];
            [[APIManager sharedManager] checkInWtihShopId:self.selectedShopId
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      NSLog(@"%@", responseObject);
                                                      [SVProgressHUD showInfoWithStatus:@"Done"];
                                                      [self performSegueWithIdentifier:Segue_ShowShopsViewController sender:nil];
                                                      
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                      NSLog(@"%@", error);
                                                  }];
        }   
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:Segue_ShowShopsViewController]) {
        ShopDetailViewController *shopController = [segue destinationViewController];
        shopController.shopInfo = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i", self.selectedShopId] forKey:key_shop_id];
    }
}

@end
