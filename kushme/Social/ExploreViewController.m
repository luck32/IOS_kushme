//
//  ExploreViewController.m
//  kushme
//
//  Created by Nicolas Rostov on 20/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ExploreViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserHeaderViewCell.h"
#import "FriendsPostCell.h"
#import "SocialPostCell.h"
#import "SinglePostController.h"
#import "SearchUserViewCell.h"
#import "UserProfileController.h"

typedef enum : NSUInteger {
    kModeExplore,
    kModeUserSearch,
    kModeMyPosts,
    kModeFriendsFeed
} SocialScreenMode;

@interface ExploreViewController () <UISearchBarDelegate> {
    SocialScreenMode screenMode;
}

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSArray *userPictures;
@property (nonatomic, strong) NSArray *friendsPosts;

-(IBAction)searchUserAction:(id)sender;
-(IBAction)pageSwitchAction:(id)sender;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    screenMode = kModeExplore;
    
    if(![[APIManager sharedManager] isUserLoggedIn]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please login to explore user pictures" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
    }
    else {
        [self updateSocialFeedShowingSpinner:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[APIManager sharedManager] isUserLoggedIn]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchUserAction:)];
        if([self.posts count] == 0) {
            [self updateSocialFeedShowingSpinner:YES];
        }
        
        // Added by meimei
        if (self.showSocialSearch) {
            [self searchUserAction:nil];
        }
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.collectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LoadData
-(void)updateSocialFeedShowingSpinner:(BOOL)showSpinner {
    if(showSpinner)
        [SVProgressHUD show];
    [[APIManager sharedManager] getRandomPosts:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if([responseObject isKindOfClass:[NSArray class]]) {
            self.posts = [NSArray arrayWithArray:responseObject];
            [self.collectionView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Unexpected API return"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

-(void)updateUserDataShowingSpinner:(BOOL)showSpinner {
    if(showSpinner)
        [SVProgressHUD show];
    [[APIManager sharedManager] getSocialProfileForUser:[[APIManager sharedManager] getUserId]
                                                profile:0
                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    [SVProgressHUD popActivity];
                                                    if([responseObject isKindOfClass:[NSDictionary class]]) {
                                                        self.userData = [NSDictionary dictionaryWithDictionary:responseObject];
                                                        [self.collectionView reloadData];
                                                    }
                                                    else {
                                                        [SVProgressHUD showErrorWithStatus:@"Unexpected API return"];
                                                    }
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                }];
    [[APIManager sharedManager] getSocialPicListForUser:[[APIManager sharedManager] getUserId]
                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    [SVProgressHUD popActivity];
                                                    if([responseObject isKindOfClass:[NSArray class]]) {
                                                        self.userPictures = [NSArray arrayWithArray:responseObject];
                                                    }
                                                    [self.collectionView reloadData];
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                }];
}

-(void)updateFriendsFeedShowingSpinner:(BOOL)showSpinner {
    if(showSpinner)
        [SVProgressHUD show];
    [[APIManager sharedManager] getFriendsPosts:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if([responseObject isKindOfClass:[NSArray class]]) {
            self.friendsPosts = [NSArray arrayWithArray:responseObject];
            [self.collectionView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Unexpected API return"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark Actions
-(IBAction)pageSwitchAction:(UISegmentedControl*)sender {
    [SVProgressHUD dismiss];
    if(sender.selectedSegmentIndex == 0) {
        screenMode = kModeExplore;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchUserAction:)];
    }
    else if(sender.selectedSegmentIndex == 1) {
        screenMode = kModeMyPosts;
        self.navigationItem.rightBarButtonItem = nil;
        [self updateUserDataShowingSpinner:(self.userData == nil)];
    }
    else if(sender.selectedSegmentIndex == 2) {
        screenMode = kModeFriendsFeed;
        [self updateFriendsFeedShowingSpinner:YES];
    }
    [self.collectionView reloadData];
}

-(IBAction)searchUserAction:(id)sender {
    if(screenMode == kModeExplore) {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        self.navigationItem.titleView = searchBar;
        searchBar.prompt = @"email ID";
        searchBar.translucent = NO;
        searchBar.delegate = self;
        [searchBar becomeFirstResponder];
        screenMode = kModeUserSearch;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(searchUserAction:)];
    }
    else {
        self.navigationItem.titleView = nil;
        screenMode = kModeExplore;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchUserAction:)];
    }
    [SVProgressHUD dismiss];
    [self.collectionView reloadData];
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:Segue_ShowUserPost]) {
        SinglePostController *postController = [segue destinationViewController];
        if([sender respondsToSelector:@selector(data)]) {
            postController.postData = [sender performSelector:@selector(data)];
        }
    }
    else if([segue.identifier isEqualToString:Segue_ShowUserProfile]) {
        if([sender respondsToSelector:@selector(data)]) {
            NSDictionary *userData = [sender performSelector:@selector(data)];
            int user_id = [userData[key_user_master_id] intValue];
            UserProfileController *userController = [segue destinationViewController];
            userController.user_id = user_id;
        }
    }
}


#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self performSegueWithIdentifier:Segue_ShowLogin sender:self];
    }
}

#pragma mark <UICollectionView>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(screenMode == kModeExplore)
        return [self.posts count];
    else if (screenMode == kModeUserSearch)
        return [self.users count];
    else if (screenMode == kModeMyPosts)
        return [self.userPictures count] + 1;
    else if (screenMode == kModeFriendsFeed)
        return [self.friendsPosts count];
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(screenMode == kModeExplore) {
        SocialPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SocialPostCell" forIndexPath:indexPath];
        [cell setData:self.posts[indexPath.row]];
        return cell;
    }
    if(screenMode == kModeUserSearch) {
        SearchUserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchUserViewCell" forIndexPath:indexPath];
        [cell setData:self.users[indexPath.row]];
        return cell;
    }
    if (screenMode == kModeMyPosts) {
        if(indexPath.row == 0) {
            UserHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserHeaderViewCell" forIndexPath:indexPath];
            [cell setData:self.userData];
            return cell;
        }
        else {
            
            SocialPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SocialPostCell" forIndexPath:indexPath];
            [cell setData:self.userPictures[indexPath.row-1]];
            return cell;
        }
    }
    if (screenMode == kModeFriendsFeed) {
        FriendsPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsPostCell" forIndexPath:indexPath];
        [cell setData:self.friendsPosts[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize result;
    if(screenMode == kModeExplore) {
        result.width = (collectionView.frame.size.width)/3-1;
        result.height = result.width;
    }
    else if (screenMode == kModeUserSearch) {
        result.width = collectionView.frame.size.width;
        result.height = 49;
    }
    else if (screenMode == kModeMyPosts) {
        if(indexPath.row == 0) {
            result.width = collectionView.frame.size.width;
            result.height = 124 + (collectionView.frame.size.width / (320/124) - 124)/3;
        }
        else {
            result.width = collectionView.frame.size.width;
            result.height = result.width;
        }
    }
    else if(screenMode == kModeFriendsFeed) {
        result.width = collectionView.frame.size.width;
        result.height = result.width + 32;
    }
    return result;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ExploreHeader" forIndexPath:indexPath];
    if (screenMode == kModeUserSearch || ![[APIManager sharedManager] isUserLoggedIn]) {
        view.userInteractionEnabled = NO;
        view.alpha = 0.5;
    }
    else if(screenMode == kModeExplore) {
        view.userInteractionEnabled = YES;
        view.alpha = 1;
    }
    return view;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [SVProgressHUD show];
    [[APIManager sharedManager] searchUsername:searchBar.text
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [SVProgressHUD dismiss];
                                           if([responseObject isKindOfClass:[NSArray class]]) {
                                               self.users = [NSArray arrayWithArray:responseObject];
                                               [self.collectionView reloadData];
                                           }
                                           else {
                                               [SVProgressHUD showErrorWithStatus:@"Unexpected API return"];
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [SVProgressHUD dismiss];
                                           [[AlertManager sharedManager] showErrorAlert:[error localizedDescription] onVC:self];
                                       }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    screenMode = kModeExplore;
    [self.collectionView reloadData];
}

@end
