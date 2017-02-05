//
//  SearchUserViewCell.m
//  kushme
//
//  Created by Nicolas Rostov on 6/6/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "SearchUserViewCell.h"
#import "APIManager.h"

@interface SearchUserViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* characterView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* addressLabel;
@property (weak, nonatomic) IBOutlet UIButton* followButton;

- (IBAction)tapFollowButton:(UIButton*)sender;

@end

@implementation SearchUserViewCell

-(void)prepareForReuse {
    self.nameLabel.text = @"";
    [self.characterView setImage:nil];
    self.addressLabel.text = @"";
}

-(void)setData:(NSDictionary *)data {
    [self prepareForReuse];
    _data = data;
    
    if(data[key_user_picture]) {
        NSString *userPicUrl = [data[key_user_picture] stringByRemovingPercentEncoding];
        [self.characterView setImageWithURL:[NSURL URLWithString:userPicUrl]];
    }
    NSString* username = [UtilManager validateResponse:[data objectForKey:key_user_name]];
    NSString* city = [UtilManager validateResponse:[data objectForKey:key_user_city]];
    NSString* state = [UtilManager validateResponse:[data objectForKey:key_user_state]];
    
    NSString* address = city.length > 0 ? [city stringByAppendingFormat:@", %@", state] : state;
    
    self.nameLabel.text = username;
    self.addressLabel.text = address;
    self.followButton.selected = ![[data[key_follow_message] lowercaseString] isEqualToString:@"follow"];
}

- (IBAction)tapFollowButton:(UIButton*)sender {
    [SVProgressHUD show];
    [[APIManager sharedManager] followUser:[self.data[key_user_master_id] intValue]
                                   message:self.data[key_follow_message]
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:self.data];
                                       newData[key_follow_message] = responseObject[@"message"];
                                       self.data = [NSDictionary dictionaryWithDictionary:newData];
                                       [SVProgressHUD dismiss];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                   }];
}

@end
