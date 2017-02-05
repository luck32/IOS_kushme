//
//  UserHeaderViewCell.m
//  kushme
//
//  Created by Nicolas Rostov on 21/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "UserHeaderViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface UserHeaderViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *picturesLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingsLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

-(IBAction)followAction:(id)sender;

@end

@implementation UserHeaderViewCell

-(void)awakeFromNib {
    [self.userImage setImage:nil];
    self.nameLabel.text = nil;
    self.picturesLabel.text = nil;
    self.followersLabel.text = nil;
    self.followingsLabel.text = nil;
    
    self.followButton.tintColor = TINT_COLOR;
    self.followButton.layer.borderColor = [TINT_COLOR CGColor];
    self.followButton.layer.borderWidth = 1;
    self.followButton.layer.cornerRadius = 2;
    self.followButton.hidden = YES;
    [self.followButton setTitle:@"" forState:UIControlStateNormal];
    
    self.backView.layer.shadowOffset = CGSizeMake(1, 4);
    self.backView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.backView.layer.shadowOpacity = 0.5;
}

-(void)setData:(NSDictionary *)data {
    _data = data;
    if(!data)
        return;
    if(data[key_user_picture]) {
        NSString *userPicUrl = [data[key_user_picture] stringByRemovingPercentEncoding];
        [self.userImage setImageWithURL:[NSURL URLWithString:userPicUrl]];
    }
    if(data[key_user_name])
        self.nameLabel.text = data[key_user_name];
    else
        self.nameLabel.text = @"Unknown user";
    self.picturesLabel.text = [NSString stringWithFormat:@"%@\nPICTURES", data[key_user_noofpic]?:@""];
    self.followersLabel.text = [NSString stringWithFormat:@"%@\nFOLLOWER", data[key_user_nooffollow]?:@""];
    self.followingsLabel.text = [NSString stringWithFormat:@"%@\nFOLLOWING", data[key_user_nooffollowing]?:@""];
    
    NSLog(@"%@", self.data[key_follow_message]);
    self.followButton.hidden = ([data[key_user_master_id] intValue] == [[APIManager sharedManager] getUserId]);
    if([self.data[key_follow_message] isEqualToString:@"Own"])
        self.followButton.hidden = YES;
    [self.followButton setTitle:[self.data[key_follow_message] capitalizedString] forState:UIControlStateNormal];
}

-(IBAction)followAction:(id)sender {
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
