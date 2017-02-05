//
//  ShopsCell.m
//  kushme
//
//  Created by Yanny on 5/16/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopsCell.h"

@implementation ShopsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    
    return UIEdgeInsetsZero;
}

- (void)setRate:(int)rate {
    
    self.rateButton1.selected = rate >= 1;
    self.rateButton2.selected = rate >= 2;
    self.rateButton3.selected = rate >= 3;
    self.rateButton4.selected = rate >= 4;
    self.rateButton5.selected = rate >= 5;
}

- (BOOL)isMultilineShopName:(NSString*)shopName {
    
    CGRect rect = [shopName boundingRectWithSize:CGSizeMake(self.shopNameLabel.frame.size.width, 9999.f)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: self.shopNameLabel.font}
                                         context:nil];
    if (rect.size.height > self.shopNameLabel.frame.size.height / 2)
        return YES;
    
    return NO;
}

@end