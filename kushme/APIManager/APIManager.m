//
//  APIManager.m
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (APIManager*)sharedManager {
    
    static APIManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (AFHTTPRequestOperationManager*)operationManager {
    
    AFHTTPRequestOperationManager* operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [operationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [operationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    return operationManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (NSString*)deviceToken {
    
    NSString* uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (uuid && uuid.length > 0)
        return uuid;
    
    return @"";
}

-(NSString*)getUsername {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kushme_username];
}

-(int)getUserId {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kushme_userid] intValue];
}

-(NSString*)getUserCode {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kushme_user_code];
}

-(BOOL)isUserLoggedIn {
    return [self getUserId] > 0;
}

- (void)resetUsername:(NSString*)username email:(NSString*)email {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kushme_username];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kushme_email];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetPassword:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kushme_password];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary*)getUserDetails {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kushme_user_details];
}

- (UserPrivacy)getUserPrivacy {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kushme_user_privacy] intValue];
}

- (void)setUserPrivacy:(UserPrivacy)privacy {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:privacy] forKey:kushme_user_privacy];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

- (void)signout {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_email];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_password];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_username];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_userid];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_user_code];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_user_details];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_user_privacy];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserLoginStateChanged object:self];
}

- (NSDictionary*)signupWithUsername:(NSString*)username
                              email:(NSString*)email
                           password:(NSString*)password
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSDictionary* params = @{key_token: [self deviceToken],
                             key_email: email,
                             key_username: username,
                             key_password: password,
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [self signout];
    
    [operationManager POST:SignupUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:kushme_email];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kushme_password];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[key_username] forKey:kushme_username];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[key_userid] forKey:kushme_userid];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[kushme_user_code] forKey:kushme_user_code];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        success(operation, responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserLoginStateChanged object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return nil;
}

- (NSDictionary*)loginWithUsername:(NSString*)email
                          password:(NSString*)password
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uname: email,
                             key_password: password,
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];

    [self signout];
    
    [operationManager POST:LoginUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:kushme_email];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kushme_password];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[key_username] forKey:kushme_username];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[key_userid] forKey:kushme_userid];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[kushme_user_code] forKey:kushme_user_code];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        success(operation, responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserLoginStateChanged object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return nil;
}

- (NSDictionary*)forgotPasswordWithEmail:(NSString*)email
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uemail: email
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ForgotPasswordUrl parameters:params success:success failure:failure];
    
    return nil;
}

- (NSDictionary*)changePassword:(NSString*)oldPassword
                           with:(NSString*)newPassword
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSNumber* userMasterId = [[self getUserDetails] objectForKey:key_user_master_id];
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_userid: userMasterId,
                             key_oldpass: oldPassword,
                             key_newpass: newPassword
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ChangePasswordUrl parameters:params success:success failure:failure];
    
    return nil;
}

- (NSDictionary*)checkInWtihShopId:(int)shopId
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId]),
                             key_shopid: @(shopId)
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:CheckInUrl parameters:params success:success failure:failure];
    
    return nil;
}

- (NSDictionary*)shopListWithLatitude:(double)latitude
                            longitude:(double)longitude
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_lat1: [NSNumber numberWithDouble:latitude],
                             key_lon1: [NSNumber numberWithDouble:longitude]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopListSearchUrl parameters:params success:success failure:failure];
    
    return nil;
}

- (void)searchShopListWithName:(NSString*)shopName
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_name: shopName
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopNameSearchUrl parameters:params success:success failure:failure];
}

- (void)searchShopListWithName:(NSString*)shopName
                      menuName:(NSString*)menuName
                      location:(NSString*)location
                          latitude:(double)latitude
                         longitude:(double)longitude
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_name: shopName,
                             key_menu_name: menuName,
//                             key_location: location,
                             key_location: @"",
                             key_lat1: [NSNumber numberWithDouble:latitude],
                             key_lon1: [NSNumber numberWithDouble:longitude]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopSearchUrl parameters:params success:success failure:failure];
}

- (void)shopListNearMeWithLatitude:(double)latitude
                         longitude:(double)longitude
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_lat1: [NSNumber numberWithDouble:latitude],
                             key_lon1: [NSNumber numberWithDouble:longitude]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopListNearMeUrl parameters:params success:success failure:failure];
}

- (void)shopListFavoriteWithLatitude:(double)latitude
                           longitude:(double)longitude
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId]),
                             key_lat1: [NSNumber numberWithDouble:latitude],
                             key_lon1: [NSNumber numberWithDouble:longitude]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopListFavoriteUrl parameters:params success:success failure:failure];
}

- (void)getShopDetailsWithShopId:(NSString*)shopId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId]),
                             key_shop_id: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SingleShopDetailsUrl parameters:params success:success failure:failure];
}

- (void)getSavedDeals:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SavedDealsUrl parameters:params success:success failure:failure];
}

- (void)uploadImage:(NSString*)base64Image
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId]),
                             key_image_string: base64Image
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:UploadImageUrl parameters:params success:success failure:failure];
}


- (void)insertRatings:(float)ratingValue shop:(NSString*)shopId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId]),
                             key_Ratings_string: [NSNumber numberWithFloat:ratingValue],
                             key_shpid: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:InsertShopRating parameters:params success:success failure:failure];
}



- (void)insertReviews:(NSString*)review shop:(NSString*)shopId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId]),
                             key_shop_review: review,
                             key_shpid: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:InsertShopReview parameters:params success:success failure:failure];
}


- (void)shopFollow_Unfollow:(NSString*)shopId
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_follower_user_id: @([self getUserId]),
                             key_follower_shop_id: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:Shop_Follow_Unfollow parameters:params success:success failure:failure];
}


- (void)showShopPicture:(NSString*)shopId picCount:(double)pictureNumber
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_id: shopId,
                             key_pic_number: [NSNumber numberWithDouble:pictureNumber]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:Show_Shop_Picture parameters:params success:success failure:failure];
}


- (void)showShopReview:(double)shopId
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_id: [NSNumber numberWithDouble:shopId],
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:Show_Shop_Reviews parameters:params success:success failure:failure];
}


- (void)getMessageGroups:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:MessageGroupsUrl parameters:params success:success failure:failure];
}
- (void)getMessagesForSender:(int)sender_id
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId]),
                             key_sender_id: @(sender_id)
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:MessagesUrl parameters:params success:success failure:failure];
}

- (void)deleteMessageId:(int)message_id
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_message_id: @(message_id)
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:DeleteMessageUrl parameters:params success:success failure:failure];
}

- (void)getMyShops:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:MyShopsUrl parameters:params success:success failure:failure];
}

- (void)getMyDeals:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_deal_createdby: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:MyDealsUrl parameters:params success:success failure:failure];
}

- (void)getNearMeDealsWithLatitude:(double)latitude
                         longitude:(double)longitude
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_lat1: [NSNumber numberWithDouble:latitude],
                             key_lon1: [NSNumber numberWithDouble:longitude]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:DealsNearMeUrl parameters:params success:success failure:failure];
}

- (void)getFavoriteDeals:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:DealsFavoriteUrl parameters:params success:success failure:failure];
}

- (void)getUserDetails:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uname: [self getUsername]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_user_details];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [operationManager POST:UserDetailsUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary* userDetails = nil;
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                userDetails = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                userDetails = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectAtIndex:0]];
            }
        }
        
        if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:userDetails forKey:kushme_user_details];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        success(operation, userDetails);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)getUserInfo:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_user_details];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [operationManager POST:UserInfoUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary* userDetails = nil;
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                userDetails = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                userDetails = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectAtIndex:0]];
            }
        }
        
        if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:userDetails forKey:kushme_user_details];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        success(operation, userDetails);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)editUserProfileWithUsername:(NSString*)username
                              email:(NSString*)email
                            address:(NSString*)address
                               city:(NSString*)city
                              state:(NSString*)state
                                zip:(NSString*)zip
                              phone:(NSString*)phone
                         profilePic:(NSString*)base64Image
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId]),
                             key_uname: username,
                             key_address: address,
                             key_city: city,
                             key_state: state,
                             key_zip: zip,
                             key_phone: phone,
                             key_uemail: email,
                             key_uprofilepic: base64Image
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:EditUserProfileUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber* result = [responseObject objectForKey:key_message];
                if (result.intValue == 1) {
                    
                    [self resetUsername:username email:email];
                    
                    NSMutableDictionary* userDetails = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kushme_user_details]];
                    if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
                        [userDetails setObject:address forKey:key_user_address];
                        [userDetails setObject:city forKey:key_user_city];
                        [userDetails setObject:state forKey:key_user_state];
                        [userDetails setObject:zip forKey:key_user_zip];
                        [userDetails setObject:phone forKey:key_user_phone];
                        
                        NSString* newProfileUrl = [UtilManager validateResponse:[responseObject objectForKey:key_user_picture]];
                        if (newProfileUrl && newProfileUrl.length > 0) {
                            [userDetails setObject:newProfileUrl forKey:key_user_picture];
                        }
                        
                        [[NSUserDefaults standardUserDefaults] setObject:userDetails forKey:kushme_user_details];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
        }
        
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)getFollowerList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialFollowerListUrl parameters:params success:success failure:failure];
}

- (void)followUser:(int)user_id
           message:(NSString*)message
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_follow_user_log_id: @([self getUserId]),
                             key_follow_user_follow_id: @(user_id),
                             @"message": message
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:FollowRequestUrl parameters:params success:success failure:failure];
}

- (void)getFollowingList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialFollowListUrl parameters:params success:success failure:failure];
}

- (void)getFollowRequestList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure; {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:FollowRequestListUrl parameters:params success:success failure:failure];
}

- (void)acceptFollowerRequest:(NSString*)followUserId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId]),
                             key_follow_user_id: followUserId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialAcceptRequestUrl parameters:params success:success failure:failure];
}

- (void)deleteFollowRequest:(NSString*)followUserId
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId]),
                             key_follow_user_id: followUserId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialDeleteRequestUrl parameters:params success:success failure:failure];
}

- (void)sendFollowUserStatus:(NSString*)statusUpdatesOfJson
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_data: statusUpdatesOfJson};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    [operationManager POST:FollowUnfollowUserUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
            failure(operation, error);
    }];
}

- (void)sendAcceptOrDeleteRequestStatus:(NSString*)statusUpdatesOfJson
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_data: statusUpdatesOfJson};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    [operationManager POST:SocialRequestUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
            failure(operation, error);
    }];
}

- (void)getRandomPosts:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken]};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ExploreUrl parameters:params success:success failure:failure];
}

- (void)getFriendsPosts:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:FriendsFeedUrl parameters:params success:success failure:failure];
}

- (void)getPicture:(int)pic_id
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_picture_id: @(pic_id)};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialSinglePicUrl parameters:params success:success failure:failure];
}

- (void)postComment:(NSString*)comment
          toPicture:(int)pic_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             @"picid": @(pic_id),
                             @"userid": @([self getUserId]),
                             key_comment: comment};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialPostPicCommentUrl parameters:params success:success failure:failure];
}

- (void)getCommentsForPicture:(int)pic_id
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_picture_id: @(pic_id)};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialSinglePicCommentsUrl parameters:params success:success failure:failure];
}

- (void)likePicture:(int)pic_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             @"picid": @(pic_id),
                             @"userid": @([self getUserId])};
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialLikePictureUrl parameters:params success:success failure:failure];
}

- (void)searchUsername:(NSString*)username
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_email: username,
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SearchUsernameUrl parameters:params success:success failure:failure];
}

- (void)getSocialProfileForUser:(int)user_id
                        profile:(int)profile_id
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @(user_id),
                             key_profile_id: @(profile_id)
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialProfileUrl parameters:params success:success failure:failure];
}

- (void)getSocialPicListForUser:(int)user_id
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @(user_id)
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:SocialPicListUrl parameters:params success:success failure:failure];
}

- (void)getUserPrivacy:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kushme_user_privacy];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [operationManager POST:UserPrivacyStatusUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UserPrivacy userPrivacy = UserPrivacy_None;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSString* privacyString = [responseObject objectForKey:key_message];
            if (privacyString && [privacyString isKindOfClass:[NSString class]]) {
                if ([privacyString.lowercaseString isEqualToString:key_public])
                    userPrivacy = UserPrivacy_Public;
                else if ([privacyString.lowercaseString isEqualToString:key_private])
                    userPrivacy = UserPrivacy_Private;
            }
        }
        
        NSNumber* privacyNumber = [NSNumber numberWithInt:userPrivacy];
        [[NSUserDefaults standardUserDefaults] setObject:privacyNumber forKey:kushme_user_privacy];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        success(operation, privacyNumber);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)setUserPrivacy:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:UserPrivacySetUrl parameters:params success:success failure:failure];
}

- (void)getShopTimeWithShopId:(NSString*)shopId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_id: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopTimeUrl parameters:params success:success failure:failure];
}

- (void)getShopMenuWithShopId:(NSString*)shopId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_id: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:ShopMenuUrl parameters:params success:success failure:failure];
}

- (void)getDealDetailsOfShopId:(NSString*)shopId
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_id: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:DealDetailsUrl parameters:params success:success failure:failure];
}

- (void)getSavedDealDetailsWithDealId:(NSString*)dealId
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_deal_id: dealId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:DealShowSingleUrl parameters:params success:success failure:failure];
}

- (void)getNewDealWith:(NSString*)dealId
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_uid: @([self getUserId]),
                             key_deal_id: dealId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:GetDealUrl parameters:params success:success failure:failure];
}

- (void)getDealOfShop:(NSString*)shopId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_shop_id: shopId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:DealOfShopUrl parameters:params success:success failure:failure];
}

- (void)getNumberOfUnreadMessages:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_token: [self deviceToken],
                             key_user_id: @([self getUserId])
                             };
    
    AFHTTPRequestOperationManager* operationManager = [[self class] operationManager];
    
    [operationManager POST:NoOfUnreadessagesURL parameters:params success:success failure:failure];
}

@end
