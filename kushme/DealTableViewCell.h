//
//  DealTableViewCell.h
//  kushme
//
//  Created by Nicolas Rostov on 15/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell

- (void)setCellData:(NSDictionary*)cellData;
- (void)setDetailsTarget:(id)target action:(SEL)action tag:(NSInteger)tag;

@end
