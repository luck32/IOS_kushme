//
//  APIManager.h
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (APIManager*)sharedManager;
+ (AFHTTPRequestOperationManager*)operationManager;

- (instancetype)init;

- (NSString*)deviceToken;

-(NSString*)getUsername;
-(int)getUserId;
-(NSString*)getUserCode;
-(BOOL)isUserLoggedIn;

- (void)resetUsername:(NSString*)username email:(NSString*)email;
- (void)resetPassword:(NSString*)password;

- (NSDictionary*)getUserDetails;
- (UserPrivacy)getUserPrivacy;
- (void)setUserPrivacy:(UserPrivacy)privacy;
- (void)signout;

- (NSDictionary*)signupWithUsername:(NSString*)username
                              email:(NSString*)email
                           password:(NSString*)password
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (NSDictionary*)loginWithUsername:(NSString*)username
                          password:(NSString*)password
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (NSDictionary*)forgotPasswordWithEmail:(NSString*)email
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (NSDictionary*)changePassword:(NSString*)oldPassword
                           with:(NSString*)newPassword
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (NSDictionary*)checkInWtihShopId:(int)shopId
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (NSDictionary*)shopListWithLatitude:(double)latitude
                            longitude:(double)longitude
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)searchShopListWithName:(NSString*)shopName
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)searchShopListWithName:(NSString*)shopName
                      menuName:(NSString*)menuName
                      location:(NSString*)location
                      latitude:(double)latitude
                     longitude:(double)longitude
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)shopListNearMeWithLatitude:(double)latitude
                         longitude:(double)longitude
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)shopListFavoriteWithLatitude:(double)latitude
                           longitude:(double)longitude
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getShopDetailsWithShopId:(NSString*)shopId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getSavedDeals:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)uploadImage:(NSString*)base64Image
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)insertRatings:(float)ratingValue shop:(NSString*)shopId
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)insertReviews:(NSString*)review shop:(NSString*)shopId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)shopFollow_Unfollow:(NSString*)shopId
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)showShopPicture:(NSString*)shopId picCount:(double)pictureNumber
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)showShopReview:(double)shopId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)getMessageGroups:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getMessagesForSender:(int)sender_id
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)deleteMessageId:(int)message_id
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getMyShops:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getMyDeals:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getNearMeDealsWithLatitude:(double)latitude
                         longitude:(double)longitude
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getFavoriteDeals:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getUserDetails:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getUserInfo:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)editUserProfileWithUsername:(NSString*)username
                              email:(NSString*)email
                            address:(NSString*)address
                               city:(NSString*)city
                              state:(NSString*)state
                                zip:(NSString*)zip
                              phone:(NSString*)phone
                         profilePic:(NSString*)base64Image
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getFollowerList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getFollowingList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)followUser:(int)user_id
           message:(NSString*)message
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getFollowRequestList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)acceptFollowerRequest:(NSString*)followUserId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)deleteFollowRequest:(NSString*)followUserId
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)sendFollowUserStatus:(NSString*)statusUpdatesOfJson
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)sendAcceptOrDeleteRequestStatus:(NSString*)statusUpdatesOfJson
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getRandomPosts:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getFriendsPosts:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getPicture:(int)pic_id
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getCommentsForPicture:(int)pic_id
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postComment:(NSString*)comment
          toPicture:(int)pic_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)likePicture:(int)pic_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)searchUsername:(NSString*)username
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getSocialProfileForUser:(int)user_id
                        profile:(int)profile_id
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getSocialPicListForUser:(int)user_id
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getUserPrivacy:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)setUserPrivacy:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getShopTimeWithShopId:(NSString*)shopId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getShopMenuWithShopId:(NSString*)shopId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getDealDetailsOfShopId:(NSString*)shopId
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getSavedDealDetailsWithDealId:(NSString*)dealId
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getNewDealWith:(NSString*)dealId
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getDealOfShop:(NSString*)shopId
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getNumberOfUnreadMessages:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
