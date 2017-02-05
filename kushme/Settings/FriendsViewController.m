//
//  FriendsViewController.m
//  kushme
//
//  Created by Yanny on 5/19/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
#import "UserProfileController.h"
#import "ExploreViewController.h"

@interface FriendsViewController ()

@property (weak, nonatomic) IBOutlet UIView* followerBorderView;
@property (weak, nonatomic) IBOutlet UIView* followingBorderView;
@property (weak, nonatomic) IBOutlet UIView* requestBorderView;
@property (weak, nonatomic) IBOutlet UITableView* followerTableView;
@property (weak, nonatomic) IBOutlet UITableView* followingTableView;
@property (weak, nonatomic) IBOutlet UITableView* requestTableView;

@property (strong, nonatomic) NSMutableArray* followerResults;
@property (strong, nonatomic) NSMutableArray* followingResults;
@property (strong, nonatomic) NSMutableArray* requestResults;

- (IBAction)tapTabButton:(UIButton*)sender;
- (IBAction)tapSearchButton:(UIButton*)sender;
- (IBAction)tapFollowButton:(UIButton*)sender;
- (IBAction)tapAcceptButton:(UIButton*)sender;
- (IBAction)tapCancelButton:(UIButton*)sender;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"FRIENDS LIST";
    
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0.f, 0.f, 85.f, 32.f);
    [searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [searchButton setImage:[UIImage imageNamed:@"btn_friends_search"] forState:UIControlStateNormal];
    [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 3.f)];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setTitleColor:TINT_COLOR forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(tapSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
//    [self loadFollowingUsers];
    [self showFriendsWithTab:FriendsTab_Following];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self sendFollowUserStatusWithTab:(FriendsTab)self.view.tag showProgressHUD:NO success:nil failure:nil];
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
    if ([tableView isEqual:self.followerTableView])
        return [self.followerResults count];
    else if ([tableView isEqual:self.followingTableView])
        return [self.followingResults count];
    else if ([tableView isEqual:self.requestTableView])
        return [self.requestResults count];
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.separatorInset = UIEdgeInsetsZero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsCell *cell = (FriendsCell*)[tableView dequeueReusableCellWithIdentifier:@"FriendsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary* friendDict = nil;
    if ([tableView isEqual:self.followerTableView]) {
        friendDict = [self.followerResults objectAtIndex:indexPath.row];
    }
    else if ([tableView isEqual:self.followingTableView]) {
        friendDict = [self.followingResults objectAtIndex:indexPath.row];
    }
    else if ([tableView isEqual:self.requestTableView]) {
        friendDict = [self.requestResults objectAtIndex:indexPath.row];
    }
    
    if (friendDict) {
        // set logo
        NSString* logoUrl = [friendDict objectForKey:key_user_picture];
        if (logoUrl) {
            logoUrl = logoUrl.stringByRemovingPercentEncoding;
            [cell.characterView setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
        }
        
        
        NSString* username = [UtilManager validateResponse:[friendDict objectForKey:key_username]];
        NSString* city = [UtilManager validateResponse:[friendDict objectForKey:key_user_city]];
        NSString* state = [UtilManager validateResponse:[friendDict objectForKey:key_user_state]];
        
        NSString* address = city.length > 0 ? [city stringByAppendingFormat:@", %@", state] : state;
        
        cell.nameLabel.text = username;
        cell.addressLabel.text = address;
        cell.acceptButton.tag = indexPath.row;
        cell.cancelButton.tag = indexPath.row;
        cell.followButton.tag = indexPath.row;
        [cell showRequestWrapper:[tableView isEqual:self.requestTableView]];
        
        FollowStatus followStatus = [[friendDict objectForKey:key_follow_status] intValue];
        cell.followButton.selected = (followStatus == FollowStatus_Following);
        
        int acceptDeleteStatus = [[friendDict objectForKey:key_accept_delete_status] intValue];
        cell.acceptButton.selected = acceptDeleteStatus > 9;
        cell.cancelButton.selected = (acceptDeleteStatus % 10) == 1;
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
    
    if ([segue.identifier isEqualToString:Segue_ShowUserProfile]) {
        UserProfileController* userController = [segue destinationViewController];
        userController.user_id = [sender intValue];
    }
    else if ([segue.identifier isEqualToString:Segue_ShowSocialSearch]) {
        ExploreViewController* vc = [segue destinationViewController];
        vc.showSocialSearch = YES;
    }
}


#pragma mark -
#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* friendDict = nil;
    if ([tableView isEqual:self.followerTableView]) {
        friendDict = [self.followerResults objectAtIndex:indexPath.row];
    }
    else if ([tableView isEqual:self.followingTableView]) {
        friendDict = [self.followingResults objectAtIndex:indexPath.row];
    }
    else if ([tableView isEqual:self.requestTableView]) {
        friendDict = [self.requestResults objectAtIndex:indexPath.row];
    }
    
    if (friendDict && [friendDict isKindOfClass:[NSDictionary class]]) {
        NSString* friendId = [friendDict objectForKey:key_userid];
        [self performSegueWithIdentifier:Segue_ShowUserProfile sender:friendId];
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)loadFriendsData {
    
    switch (self.view.tag) {
        case FriendsTab_Follower:
            if (!self.followerResults || self.followerResults.count < 1) {
                [self loadFollowers];
            }
            break;
        case FriendsTab_Following:
            if (!self.followingResults || self.followingResults.count < 1) {
                [self loadFollowingUsers];
            }
            break;
        case FriendsTab_Request:
            if (!self.requestResults || self.requestResults.count < 1) {
                [self loadFollowRequests];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)tapTabButton:(UIButton*)sender {
    
    if (sender.tag == self.view.tag)
        return;
    
    [self showFriendsWithTab:(FriendsTab)sender.tag];
}

- (void)showFriendsWithTab:(FriendsTab)newTab {
    
    FriendsTab friendTab = (FriendsTab)self.view.tag;
    
    self.view.tag = newTab;
    
    self.followerBorderView.alpha = self.view.tag == FriendsTab_Follower;
    self.followerTableView.alpha = self.view.tag == FriendsTab_Follower;
    self.followingBorderView.alpha = self.view.tag == FriendsTab_Following;
    self.followingTableView.alpha = self.view.tag == FriendsTab_Following;
    self.requestBorderView.alpha = self.view.tag == FriendsTab_Request;
    self.requestTableView.alpha = self.view.tag == FriendsTab_Request;
    
    if (![[APIManager sharedManager] isUserLoggedIn]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Please login so we can keep track of your friends" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        UIAlertAction* loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
        }];
        [alert addAction:loginAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    BOOL waitForUpdates = [self sendFollowUserStatusWithTab:friendTab showProgressHUD:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if DEBUG
        NSLog(@"sendFollowUserStatus : %@", responseObject);
#endif
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:key_message] boolValue]) {
                
                [self updateFriendsStatus:friendTab];
                
                switch (self.view.tag) {
                    case FriendsTab_Follower:
                        [self loadFollowers];
                        break;
                    case FriendsTab_Following:
                        [self loadFollowingUsers];
                        break;
                    case FriendsTab_Request:
                        [self loadFollowRequests];
                        break;
                        
                    default:
                        break;
                }
                return;
            }
            
            [self loadFriendsData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
        NSLog(@"sendFollowUserStatus : %@", error.localizedDescription);
#endif
        [self loadFriendsData];
    }];
    
    if (!waitForUpdates) {
        [self loadFriendsData];
    }
}

- (IBAction)tapSearchButton:(UIButton*)sender {
    
    [self performSegueWithIdentifier:Segue_ShowSocialSearch sender:nil];
}

- (void)loadFollowers {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getFollowerList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"getFollowerList : %@", responseObject);
#endif
        
        self.followerResults = [NSMutableArray arrayWithCapacity:0];
        
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
                
                for (NSString* shopKey in allKeys) {
                    NSDictionary* shopDict = [responseObject objectForKey:shopKey];
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            if (searchResults && [searchResults count] > 0) {
                for (NSDictionary* dict in searchResults) {
                    NSMutableDictionary* friendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    if (friendDict && [friendDict isKindOfClass:[NSDictionary class]]) {
                        NSString* followMessage = [UtilManager validateResponse:[friendDict objectForKey:key_follow_message]];
                        FollowStatus followStatus = [followMessage isEqualToString:key_Following] ? FollowStatus_Following : FollowStatus_Follow;
                        [friendDict setObject:[NSNumber numberWithInt:followStatus] forKey:key_follow_status];
                        
                        [self.followerResults addObject:friendDict];
                    }
                }
                [self.followerTableView reloadData];
            }
            else {
                if (self.view.tag == FriendsTab_Follower) {
                    [SVProgressHUD showInfoWithStatus:@"You have no followers"];
                    return;
                }
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"getFollowerList : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
    }];
}

- (void)loadFollowingUsers {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] getFollowingList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"getFollowingList : %@", responseObject);
#endif
        
        self.followingResults = [NSMutableArray arrayWithCapacity:0];
        
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
                
                for (NSString* shopKey in allKeys) {
                    NSDictionary* shopDict = [responseObject objectForKey:shopKey];
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            if (searchResults && [searchResults count] > 0) {
                for (NSDictionary* dict in searchResults) {
                    NSMutableDictionary* friendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    if (friendDict && [friendDict isKindOfClass:[NSDictionary class]]) {
                        NSString* followMessage = [UtilManager validateResponse:[friendDict objectForKey:key_follow_message]];
                        FollowStatus followStatus = [followMessage isEqualToString:key_Following] ? FollowStatus_Following : FollowStatus_Follow;
                        [friendDict setObject:[NSNumber numberWithInt:followStatus] forKey:key_follow_status];
                        
                        [self.followingResults addObject:friendDict];
                    }
                }
                [self.followingTableView reloadData];
            }
            else {
                if (self.view.tag == FriendsTab_Following) {
                    [SVProgressHUD showInfoWithStatus:@"You have no following users"];
                    return;
                }
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"getFollowingList : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
    }];
}

- (void)loadFollowRequests {
    
    APIManager* apiManager = [APIManager sharedManager];
    
    UserPrivacy userPrivacy = [apiManager getUserPrivacy];
    if (userPrivacy != UserPrivacy_Private) {
        [SVProgressHUD showInfoWithStatus:@"You have no pending requests"];
        return;
    }
    
    
    [SVProgressHUD show];
    
    [apiManager getFollowRequestList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#if DEBUG
        NSLog(@"getFollowRequestList : %@", responseObject);
#endif
        
        self.requestResults = [NSMutableArray arrayWithCapacity:0];
        
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
                
                for (NSString* shopKey in allKeys) {
                    NSDictionary* shopDict = [responseObject objectForKey:shopKey];
                    if (shopDict && [shopDict isKindOfClass:[NSDictionary class]])
                        [searchResults addObject:shopDict];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [searchResults addObjectsFromArray:responseObject];
            }
            
            if (searchResults && [searchResults count] > 0) {
                for (NSDictionary* dict in searchResults) {
                    NSMutableDictionary* friendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    if (friendDict && [friendDict isKindOfClass:[NSDictionary class]]) {
                        [friendDict setObject:[NSNumber numberWithInt:0] forKey:key_accept_delete_status];
                        
                        [self.requestResults addObject:friendDict];
                    }
                }
                [self.requestTableView reloadData];
            }
            else {
                if (self.view.tag == FriendsTab_Request) {
                    [SVProgressHUD showInfoWithStatus:@"You have no pending requests"];
                    return;
                }
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#if DEBUG
        NSLog(@"getFollowRequestList : %@", error.localizedDescription);
#endif
        
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)tapFollowButton:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    
    NSMutableDictionary* friendDict = nil;
    switch (self.view.tag) {
        case FriendsTab_Follower:
            friendDict = [self.followerResults objectAtIndex:sender.tag];
            break;
        case FriendsTab_Following:
            friendDict = [self.followingResults objectAtIndex:sender.tag];
            break;
        case FriendsTab_Request:
            friendDict = [self.requestResults objectAtIndex:sender.tag];
            break;
            
        default:
            break;
    }
    
    FollowStatus followStatus = [[friendDict objectForKey:key_follow_status] intValue];
    if (followStatus == FollowStatus_Following)
        followStatus = FollowStatus_Follow;
    else
        followStatus = FollowStatus_Following;
    [friendDict setObject:[NSNumber numberWithInt:followStatus] forKey:key_follow_status];
    
}

- (NSMutableArray*)getFriendsToSendFollowRequest:(FriendsTab)friendTab {
    
    NSMutableArray* friends = nil;
    if (friendTab == FriendsTab_Follower) {
        friends = self.followerResults;
    }
    else if (friendTab == FriendsTab_Following) {
        friends = self.followingResults;
    }
    else if (friendTab == FriendsTab_Request) {
        friends = self.requestResults;
    }
    
    return friends;
}

- (FollowStatus)getFollowStatusWithFollowMessage:(NSString*)followMessage {
    
    if (followMessage && [followMessage isEqualToString:key_Following])
        return FollowStatus_Following;
    
    return FollowStatus_Follow;
}

- (void)updateFriendsStatus:(FriendsTab)friendTab {
    
    NSMutableArray* friends = [self getFriendsToSendFollowRequest:friendTab];
    if (!friends || friends.count < 1) {
        return;
    }
    
    if (friendTab == FriendsTab_Request) {
        NSArray* updatedFriends = [friends filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject objectForKey:key_accept_delete_status] intValue] == 0;
        }]];
        
        self.requestResults = [NSMutableArray arrayWithArray:updatedFriends];
        [self.requestTableView reloadData];
    }
    else {
        for (NSMutableDictionary* friendDict in friends) {
            if (friendDict && [friendDict isKindOfClass:[NSDictionary class]]) {
                NSString* followMessage = [friendDict objectForKey:key_follow_message];
                FollowStatus followStatus = [[friendDict objectForKey:key_follow_status] intValue];
                if (followStatus == [self getFollowStatusWithFollowMessage:followMessage])
                    continue;
                
                NSString* message = followStatus == FollowStatus_Following ? key_Following : key_Follow;
                [friendDict setObject:message forKey:key_follow_message];
            }
        }
    }
}

- (BOOL)sendFollowUserStatusWithTab:(FriendsTab)friendTab
                    showProgressHUD:(BOOL)showProgressHUD
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableArray* friends = [self getFriendsToSendFollowRequest:friendTab];
    if (!friends || friends.count < 1) {
        return NO;
    }
    
    APIManager* apiManager = [APIManager sharedManager];
    
    NSMutableArray* statusUpdates = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableDictionary* friendDict in friends) {
        if (friendDict && [friendDict isKindOfClass:[NSDictionary class]]) {
            if (friendTab == FriendsTab_Request) {
                int acceptDeleteStatus = [[friendDict objectForKey:key_accept_delete_status] intValue];
                if (acceptDeleteStatus == 0)
                    continue;
                
//                NSNumber* followStatusResult = [friendDict objectForKey:key_follow_status_result];
                
                NSString* followUserId = [UtilManager validateResponse:[friendDict objectForKey:key_userid]];
                if (followUserId.length < 1)
                    followUserId = [UtilManager validateResponse:[friendDict objectForKey:key_follow_user_log_id]];
                NSString* message = [friendDict objectForKey:key_follow_status_result];
                
                NSDictionary* param = @{key_token: [apiManager deviceToken],
                                        key_follow_user_log_id: @([apiManager getUserId]),
                                        key_follow_user_follow_id: followUserId,
                                        key_message: message
                                        };
                [statusUpdates addObject:param];
            }
            else {
                NSString* followMessage = [friendDict objectForKey:key_follow_message];
                FollowStatus followStatus = [[friendDict objectForKey:key_follow_status] intValue];
                if (followStatus == [self getFollowStatusWithFollowMessage:followMessage])
                    continue;
                
                NSString* followUserId = [friendDict objectForKey:key_userid];
                NSString* message = followStatus == FollowStatus_Following ? key_FOLLOW : key_UNFOLLOW;
                
                NSDictionary* param = @{key_token: [apiManager deviceToken],
                                        key_follow_user_log_id: @([apiManager getUserId]),
                                        key_follow_user_follow_id: followUserId,
                                        key_message: message
                                        };
                [statusUpdates addObject:param];
            }
        }
    }
    
    if (statusUpdates.count < 1)
        return NO;
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:statusUpdates options:NSJSONWritingPrettyPrinted error:&error];
    NSString* statusUpdatesOfJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (showProgressHUD)
        [SVProgressHUD show];
    
    if (friendTab == FriendsTab_Request) {
        [apiManager sendAcceptOrDeleteRequestStatus:statusUpdatesOfJson success:success failure:failure];
    }
    else {
        [apiManager sendFollowUserStatus:statusUpdatesOfJson success:success failure:failure];
    }
    
    return YES;
}

- (IBAction)tapAcceptButton:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    
    NSMutableDictionary* friendDict = [self.requestResults objectAtIndex:sender.tag];
    
    int acceptDeleteStatus = [[friendDict objectForKey:key_accept_delete_status] intValue];
    
    if (sender.selected) {
        acceptDeleteStatus = acceptDeleteStatus + 10;
        [friendDict setObject:key_FOLLOW forKey:key_follow_status_result];
    }
    else {
        acceptDeleteStatus = acceptDeleteStatus - 10;
    }
    [friendDict setObject:[NSNumber numberWithInt:acceptDeleteStatus] forKey:key_accept_delete_status];
}

- (IBAction)tapCancelButton:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    
    NSMutableDictionary* friendDict = [self.requestResults objectAtIndex:sender.tag];
    
    int acceptDeleteStatus = [[friendDict objectForKey:key_accept_delete_status] intValue];
    
    if (sender.selected) {
        acceptDeleteStatus = acceptDeleteStatus + 1;
        [friendDict setObject:key_UNFOLLOW forKey:key_follow_status_result];
    }
    else {
        acceptDeleteStatus = acceptDeleteStatus - 1;
    }
    [friendDict setObject:[NSNumber numberWithInt:acceptDeleteStatus] forKey:key_accept_delete_status];
}

@end
