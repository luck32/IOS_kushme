//
//  Define.h
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#ifndef kushme_Define_h
#define kushme_Define_h

#define Google_Api_Key                  @"AIzaSyDq_LojRlpXQ4p30wbwwMONGadMAGCHnIQ"
//#define Google_Api_Key                      @"AIzaSyBtRWBaVse3JrwOnyTbMkiOcpczkY2533E"
#define GoogleSearch_RefererURL         @"http://plentyofcurry.com"


#define ServerUrl                       @"http://plentyofcurry.com"
#define ApiUrl                          [ServerUrl stringByAppendingPathComponent:@"api"]

#define SignupUrl                       [ApiUrl stringByAppendingPathComponent:@"signup.php"]
#define LoginUrl                        [ApiUrl stringByAppendingPathComponent:@"login.php"]
#define ForgotPasswordUrl               [ApiUrl stringByAppendingPathComponent:@"forgot_password.php"]
#define ChangePasswordUrl               [ApiUrl stringByAppendingPathComponent:@"change_password.php"]
#define ShopListSearchUrl               [ApiUrl stringByAppendingPathComponent:@"shoplist_search.php"]
#define ShopSearchUrl                   [ApiUrl stringByAppendingPathComponent:@"shop_search.php"]
#define ShopNameSearchUrl               [ApiUrl stringByAppendingPathComponent:@"shop_name_search.php"]
#define ShopListNearMeUrl               [ApiUrl stringByAppendingPathComponent:@"shoplist_nearme.php"]
#define ShopListFavoriteUrl             [ApiUrl stringByAppendingPathComponent:@"fav_shop.php"]
#define SingleShopDetailsUrl            [ApiUrl stringByAppendingPathComponent:@"single_shop_details.php"]
#define CheckInUrl                      [ApiUrl stringByAppendingPathComponent:@"checkin.php"]
#define SavedDealsUrl                   [ApiUrl stringByAppendingPathComponent:@"save_deal.php"]
#define UploadImageUrl                  [ApiUrl stringByAppendingPathComponent:@"image_base64.php"]
#define InsertShopRating                [ApiUrl stringByAppendingPathComponent:@"shop_ratting_insert.php"]
#define InsertShopReview                [ApiUrl stringByAppendingPathComponent:@"write_review_shop.php"]
#define MessageGroupsUrl                [ApiUrl stringByAppendingPathComponent:@"message_group.php"]
#define MessagesUrl                     [ApiUrl stringByAppendingPathComponent:@"message_per_sender.php"]
#define DeleteMessageUrl                [ApiUrl stringByAppendingPathComponent:@"message_delete.php"]
#define MyShopsUrl                      [ApiUrl stringByAppendingPathComponent:@"my_shop.php"]
#define MyDealsUrl                      [ApiUrl stringByAppendingPathComponent:@"my_deal.php"]
#define DealsNearMeUrl                  [ApiUrl stringByAppendingPathComponent:@"deallist_nearme.php"]
#define DealsFavoriteUrl                [ApiUrl stringByAppendingPathComponent:@"fav_deal.php"]
#define UserDetailsUrl                  [ApiUrl stringByAppendingPathComponent:@"userid_to_userdetails.php"]
#define UserInfoUrl                     [ApiUrl stringByAppendingPathComponent:@"user_info.php"]
#define EditUserProfileUrl              [ApiUrl stringByAppendingPathComponent:@"edit_user_profile.php"]
#define ExploreUrl                      [ApiUrl stringByAppendingPathComponent:@"exployer_dashboard.php"]
#define FriendsFeedUrl                  [ApiUrl stringByAppendingPathComponent:@"social_follow_pic.php"]
#define SearchUsernameUrl               [ApiUrl stringByAppendingPathComponent:@"searchby_username.php"]
#define SocialProfileUrl                [ApiUrl stringByAppendingPathComponent:@"social_profile.php"]
#define SocialPicListUrl                [ApiUrl stringByAppendingPathComponent:@"social_user_pic.php"]
#define SocialSinglePicUrl              [ApiUrl stringByAppendingPathComponent:@"social_single_pic.php"]
#define SocialLikePictureUrl            [ApiUrl stringByAppendingPathComponent:@"social_like_picture.php"]
#define SocialSinglePicCommentsUrl      [ApiUrl stringByAppendingPathComponent:@"pic_comment_show.php"]
#define SocialPostPicCommentUrl         [ApiUrl stringByAppendingPathComponent:@"social_post_comment.php"]
#define SocialFollowerListUrl           [ApiUrl stringByAppendingPathComponent:@"social_follower_list.php"]
#define FollowUnfollowUserUrl           [ApiUrl stringByAppendingPathComponent:@"user_follow_unfollow.php"]
#define SocialFollowListUrl             [ApiUrl stringByAppendingPathComponent:@"social_follow_list.php"]
#define FollowRequestListUrl            [ApiUrl stringByAppendingPathComponent:@"user_follow_request_list.php"]
#define SocialAcceptRequestUrl          [ApiUrl stringByAppendingPathComponent:@"social_accept_request.php"]
#define SocialDeleteRequestUrl          [ApiUrl stringByAppendingPathComponent:@"social_delete_request.php"]
#define UserPrivacyStatusUrl            [ApiUrl stringByAppendingPathComponent:@"user_privacy_status.php"]
#define UserPrivacySetUrl               [ApiUrl stringByAppendingPathComponent:@"user_privacy_set.php"]
#define SocialRequestUrl                [ApiUrl stringByAppendingPathComponent:@"social_request.php"]
#define FollowRequestUrl                [ApiUrl stringByAppendingPathComponent:@"single_user_request.php"]
#define Shop_Follow_Unfollow            [ApiUrl stringByAppendingPathComponent:@"shop_follow_unfollow.php"]
#define Show_Shop_Picture               [ApiUrl stringByAppendingPathComponent:@"view_shop_pic.php"]
#define Show_Shop_Reviews               [ApiUrl stringByAppendingPathComponent:@"shop_review_show.php"]
#define ShopTimeUrl                     [ApiUrl stringByAppendingPathComponent:@"shop_time.php"]
#define ShopMenuUrl                     [ApiUrl stringByAppendingPathComponent:@"shop_menu.php"]
#define DealDetailsUrl                  [ApiUrl stringByAppendingPathComponent:@"deal_details.php"]
#define DealShowSingleUrl               [ApiUrl stringByAppendingPathComponent:@"deal_show_single.php"]
#define GetDealUrl                      [ApiUrl stringByAppendingPathComponent:@"get_deal.php"]
#define DealOfShopUrl                   [ApiUrl stringByAppendingPathComponent:@"deal_list.php"]
#define NoOfUnreadessagesURL            [ApiUrl stringByAppendingPathComponent:@"no_unread_message.php"]

#define TINT_COLOR                      [UIColor colorWithRed:114./255 green:184./255 blue:63./255 alpha:1]


#define Notification_UserLocationUpdated                    @"UserLocationUpdated"
#define Notification_LocationAuthorizationStatusChanged     @"LocationAuthorizationStatusChanged"
#define Notification_UserLoginStateChanged                  @"LoginStateChanged"


#define kushme_username                 @"kushme_username"
#define kushme_user_code                @"qr_code_no"
#define kushme_userid                   @"kushme_userid"
#define kushme_email                    @"kushme_email"
#define kushme_password                 @"kushme_password"
#define kushme_master_id                @"kushme_master_id"
#define kushme_user_details             @"kushme_user_details"
#define kushme_user_privacy             @"kushme_user_privacy"

#define Segue_ShowMainTabVC             @"ShowMainTabVC"
#define Segue_ShowShopsViewController   @"ShowShopsViewController"
#define Segue_ShowShopMap               @"ShowShopMap"
#define Segue_ShowShopDetail            @"ShowShopDetail"
#define Segue_ShowLogin                 @"ShowLogin"

#define Segue_ShowSettings              @"ShowSettings"
#define Segue_ShowUserProfile           @"ShowUserProfile"
#define Segue_ShowFriendsList           @"ShowFriendsList"
#define Segue_ShowChangePassword        @"ShowChangePassword"
#define Segue_ShowMyShop                @"ShowMyShop"
#define Segue_ShowMyDeals               @"ShowMyDeals"
#define Segue_MessageDetails            @"MessageDetailsSegue"
#define Segue_ShowSocialSearch          @"ShowSocialSearch"

#define Segue_ShowUserPost              @"ShowUserPost"
#define Segue_Comment                   @"SegueComment"

#define Segue_ShowShopTime              @"ShowShopTime"
#define Segue_ShowWriteReview           @"ShowWriteReview"
#define Segue_ShowShopMenu              @"ShowShopMenu"
#define Segue_ShowDealsDetail           @"ShowDealsDetail"

#define Segue_UnwindToShopDetail        @"UnwindToShopDetail"

// Key strings

#define key_Referer                     @"Referer"

#define key_Success                     @"Success"
#define key_Fail                        @"Fail"
#define key_Done                        @"Done"

#define key_public                      @"public"
#define key_private                     @"private"

#define key_data                        @"data"

#define key_token                       @"token"
#define key_email                       @"email"
#define key_username                    @"username"
#define key_password                    @"password"
#define key_uname                       @"uname"
#define key_uemail                      @"uemail"
#define key_uid                         @"uid"
#define key_user_id                     @"user_id"
#define key_shopid                      @"shop_id"
#define key_follower_shop_id            @"follower_shop_id"
#define key_follower_user_id            @"follower_user_id"
#define key_pic_number                  @"pic_number"

#define key_user_address                @"user_address"
#define key_user_city                   @"user_city"
#define key_user_country                @"user_country"
#define key_user_date_of_birth          @"user_date_of_birth"
#define key_user_date_of_creation       @"user_date_of_creation"
#define key_user_date_of_join           @"user_date_of_join"
#define key_user_email                  @"user_email"
#define key_user_emp_master_id          @"user_emp_master_id"
#define key_user_emp_shop_id            @"user_emp_shop_id"
#define key_user_l_name                 @"user_l_name"
#define key_user_level_id               @"user_level_id"
#define key_user_master_id              @"user_master_id"
#define key_user_name                   @"user_name"
#define key_user_password               @"user_password"
#define key_user_payment_type           @"user_payment_type"
#define key_user_phone                  @"user_phone"
#define key_user_privacy                @"user_privacy"
#define key_user_profile_pic            @"user_profile_pic"
#define key_user_state                  @"user_state"
#define key_user_status                 @"user_status"
#define key_user_type_id                @"user_type_id"
#define key_profile_id                  @"profile_user_id"
#define key_user_picture                @"user_pic"
#define key_user_noofpic                @"noofpic"
#define key_user_nooffollow             @"nooffollow"
#define key_user_nooffollowing          @"nooffollowing"
#define key_user_zip                    @"user_zip"

#define key_picture_id                  @"pic_id"
#define key_post_date_diff              @"date_diff"
#define key_post_pic_id                 @"dashboard_upload_id"
#define key_post_likes                  @"no_of_like"
#define key_comment                     @"pic_comment"
#define key_comment_text                @"dashboard_upload_comment_user_comment"
#define key_post_user_id                @"dashboard_upload_user_id"

#define key_follow_message              @"follow_message"
#define key_follow_user_follow_id       @"follow_user_follow_id"
#define key_follow_user_id              @"follow_user_id"
#define key_follow_user_log_id          @"follow_user_log_id"
#define key_follow_user_starus          @"follow_user_starus"
#define key_follow_message              @"follow_message"
#define key_follow_message              @"follow_message"
#define key_follow_message              @"follow_message"
#define key_follow_message              @"follow_message"
#define key_Follow                      @"Follow"
#define key_Following                   @"Following"
#define key_follow_status               @"follow_status"
#define key_follow_status_result        @"follow_status_result"
#define key_accept_delete_status        @"accept_delete_status"

#define key_FOLLOW                      @"FOLLOW"
#define key_UNFOLLOW                    @"UNFOLLOW"

#define key_address                     @"address"
#define key_city                        @"city"
#define key_state                       @"state"
#define key_zip                         @"zip"
#define key_phone                       @"phone"
#define key_uprofilepic                 @"uprofilepic"

#define key_message                     @"message"
#define key_response                    @"responce"
#define key_userid                      @"userid"
#define key_sender_id                   @"sender_id"

#define key_oldpass                     @"oldpass"
#define key_newpass                     @"newpass"

#define key_lat1                        @"lat1"
#define key_lon1                        @"lon1"
#define key_location                    @"location"
#define key_menu_name                   @"menu_name"
#define key_geometry                    @"geometry"
#define key_lat                         @"lat"
#define key_lng                         @"lng"

#define key_menu_id                     @"menu_id"
#define key_menu_type_id                @"menu_type_id"
#define key_shop_id                     @"shop_id"
#define key_item_name                   @"item_name"
#define key_g                           @"g"
#define key_of_eight                    @"1/8"
#define key_of_four                     @"1/4"
#define key_of_two                      @"1/2"
#define key_oz                          @"oz"
#define key_ea                          @"ea."
#define key_5g                          @".5g"
#define key_menu_status                 @"menu_status"
#define key_menu_created_on             @"menu_created_on"
#define key_menu_updated_on             @"menu_updated_on"
#define key_menu_type_name              @"menu_type_name"
#define key_menu_type_status            @"menu_type_status"
#define key_menu_expanded               @"menu_expanded"
#define key_menu_items                  @"menu_items"


#define key_distance                        @"distance"
#define key_shop_address                    @"shop_address"
#define key_shop_cart                       @"shop_cart"
#define key_shop_city                       @"shop_city"
#define key_shop_closing_time               @"shop_closing_time"
#define key_shop_closing_time_monday        @"shop_closing_time_monday"
#define key_shop_closing_time_tuesday       @"shop_closing_time_tuesday"
#define key_shop_closing_time_wednesday     @"shop_closing_time_wednesday"
#define key_shop_closing_time_thursday      @"shop_closing_time_thursday"
#define key_shop_closing_time_friday        @"shop_closing_time_friday"
#define key_shop_closing_time_saturday      @"shop_closing_time_saturday"
#define key_shop_closing_time_sunday        @"shop_closing_time_sunday"
#define key_shop_contact_name               @"shop_contact_name"
#define key_shop_country                    @"shop_country"
#define key_shop_createdby                  @"shop_createdby"
#define key_shop_credit_card                @"shop_credit_card"
#define key_shop_date_of_creation           @"shop_date_of_creation"
#define key_shop_date_of_expire             @"shop_date_of_expire"
#define key_shop_dateofjoin                 @"shop_dateofjoin"
#define key_shop_decription                 @"shop_decription"
#define key_shop_email                      @"shop_email"
#define key_shop_establish_year             @"shop_establish_year"
#define key_shop_follow_msg                 @"shop_follow_msg"
#define key_shop_id                         @"shop_id"
#define key_shop_lat                        @"shop_lat"
#define key_shop_logo_pic                   @"shop_logo_pic"
#define key_shop_long                       @"shop_long"
#define key_shop_mail                       @"shop_mail"
#define key_shop_menu                       @"shop_menu"
#define key_shop_mode_id                    @"shop_mode_id"
#define key_shop_name                       @"shop_name"
#define key_shop_open_close                 @"shop_open_close"
#define key_shop_opening_time               @"shop_opening_time"
#define key_shop_opening_time_monday        @"shop_opening_time_monday"
#define key_shop_opening_time_tuesday       @"shop_opening_time_tuesday"
#define key_shop_opening_time_wednesday     @"shop_opening_time_wednesday"
#define key_shop_opening_time_thursday      @"shop_opening_time_thursday"
#define key_shop_opening_time_friday        @"shop_opening_time_friday"
#define key_shop_opening_time_saturday      @"shop_opening_time_saturday"
#define key_shop_opening_time_sunday        @"shop_opening_time_sunday"
#define key_shop_owner_id                   @"shop_owner_id"
#define key_shop_paid                       @"shop_paid"
#define key_shop_parking                    @"shop_parking"
#define key_shop_phone                      @"shop_phone"
#define key_shop_pic                        @"shop_pic"
#define key_reviewer_pic                    @"reviewer_pic"
#define key_review_message                  @"review_message"
#define key_shop_rating                     @"shop_rating"
#define key_shop_security_guard             @"shop_security_guard"
#define key_shop_state                      @"shop_state"
#define key_shop_status                     @"shop_status"
#define key_shop_time                       @"shop_time"
#define key_shop_time_zone                  @"shop_time_zone"
#define key_shop_type                       @"shop_type"
#define key_shop_voting                     @"shop_voting"
#define key_shop_website                    @"shop_website"
#define key_shop_wheel_chair                @"shop_wheel_chair"
#define key_shop_zip                        @"shop_zip"

#define key_open_time                       @"open_time"
#define key_close_time                      @"close_time"
#define key_open_time                       @"open_time"
#define key_open_time                       @"open_time"

#define key_deal_id                         @"deal_id"
#define key_deal_shop_id                    @"deal_shop_id"
#define key_deal_name                       @"deal_name"
#define key_deal_description                @"deal_description"
#define key_deal_date                       @"shop_date_of_expire"
#define key_deal_end_date                   @"deal_date_end"

#define key_deal_pic                        @"deal_pic"
#define key_deal_value                      @"deal_value"
#define key_deal_createdby                  @"deal_createdby"

#define key_user_deal_id                    @"user_deal_id"
#define key_msg                             @"msg"

#define key_image_string                    @"imagestr"
#define key_Ratings_string                  @"ratval"
#define key_shpid                           @"shpid"
#define key_shop_review                     @"shop_review"

#define key_message_id                      @"message_id"
#define key_message_details_id              @"message_details_id"
#define key_message_sender                  @"message_details_sender"
#define key_message_subject                 @"message_details_subject"
#define key_message_shop_type               @"shop_type"
#define key_message_shop_name               @"shop_name"
#define key_message_text                    @"message_details_text"
#define key_message_date                    @"message_date"
#define key_message_unread_flag             @"message_flag"
#define key_message_details_date            @"message_details_date"
#define key_message_picture                 @"shop_logo_pic"
#define key_message_shop_id                 @"message_details_shop_id"

#define key_Monday                          @"Monday"
#define key_Tuesday                         @"Tuesday"
#define key_Wednesday                       @"Wednesday"
#define key_Thursday                        @"Thursday"
#define key_Friday                          @"Friday"
#define key_Saturday                        @"Saturday"
#define key_Sunday                          @"Sunday"

#define key_success                         @"success"
#define key_noofreview                      @"noofreview"
#define key_review_client_id                @"review_client_id"
#define key_review_datetime                 @"review_datetime"
#define key_review_id                       @"review_id"
#define key_review_shop_id                  @"review_shop_id"
#define key_review_status                   @"review_status"
#define key_reviewer_name                   @"reviewer_name"


typedef enum UserType
{
    UserType_ShopOwner = 1,
    UserType_NormalUser = 2,
}
UserType;

typedef enum FriendsTab
{
    FriendsTab_Follower = 0,
    FriendsTab_Following = 1,
    FriendsTab_Request = 2,
}
FriendsTab;

typedef enum UserPrivacy
{
    UserPrivacy_None = 0,
    UserPrivacy_Public = 1,
    UserPrivacy_Private = 2,
}
UserPrivacy;

typedef enum FollowStatus
{
    FollowStatus_Follow = 0,
    FollowStatus_Following = 1,
}
FollowStatus;

#endif
