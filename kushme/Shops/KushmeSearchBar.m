//
//  KushmeSearchBar.m
//  kushme
//
//  Created by Yanny on 5/26/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "KushmeSearchBar.h"

@implementation KushmeSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setShowsCancelButton:NO animated:NO];
}

@end
