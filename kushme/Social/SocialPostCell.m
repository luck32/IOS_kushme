//
//  SocialPostCell.m
//  kushme
//
//  Created by Nicolas Rostov on 22/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "SocialPostCell.h"

@interface SocialPostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *likesImage;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation SocialPostCell

-(void)prepareForReuse {
    [self.spinner stopAnimating];
    [self.imageView setImage:nil];
    self.likesLabel.text = nil;
}

-(void)setData:(NSDictionary *)data {
    [self prepareForReuse];
    _data = data;
    if(data[key_user_picture]) {
        NSString *userPicUrl = [data[key_user_picture] stringByRemovingPercentEncoding];
        [self.spinner startAnimating];
        [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userPicUrl]]
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.imageView.image = image;
                                           [self.spinner stopAnimating];
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           [self.spinner stopAnimating];
                                       }];
    }
    if([self.data[key_post_likes] isKindOfClass:[NSString class]]) {
        self.likesLabel.text = [NSString stringWithFormat:@"%@", self.data[key_post_likes]];
        self.likesImage.hidden = NO;
        self.likesLabel.hidden = NO;
    }
    else {
        self.likesImage.hidden = YES;
        self.likesLabel.hidden = YES;
    }
}

@end
