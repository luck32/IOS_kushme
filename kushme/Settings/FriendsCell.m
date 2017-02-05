//
//  FriendsCell.m
//  kushme
//
//  Created by Yanny on 5/21/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showRequestWrapper:(BOOL)show {
    self.followWrapper.alpha = !show;
    self.followWrapper.userInteractionEnabled = !show;
    self.followRequestWrapper.alpha = show;
    self.followRequestWrapper.userInteractionEnabled = show;
}

@end
