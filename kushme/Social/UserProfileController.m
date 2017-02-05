//
//  UserProfileController.m
//  kushme
//
//  Created by Nicolas Rostov on 23/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "UserProfileController.h"
#import "UserHeaderViewCell.h"
#import "SocialPostCell.h"

@interface UserProfileController ()

@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSArray *userPictures;

@end

@implementation UserProfileController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUserDataShowingSpinner:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)updateUserDataShowingSpinner:(BOOL)showSpinner {
    if(showSpinner)
        [SVProgressHUD show];
    [[APIManager sharedManager] getSocialProfileForUser:[[APIManager sharedManager] getUserId]//  self.user_id
                                                profile:self.user_id
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
    [[APIManager sharedManager] getSocialPicListForUser:self.user_id
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.userPictures count] + 1;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize result;
    if(indexPath.row == 0) {
        result.width = collectionView.frame.size.width;
        result.height = 124 + (collectionView.frame.size.width / (320/124) - 124)/3;
    }
    else {
        result.width = collectionView.frame.size.width;
        result.height = result.width;
    }
    return result;
}

@end
