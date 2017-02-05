//
//  MessageGroupCell.m
//  kushme
//
//  Created by Nicolas Rostov on 16/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "MessageGroupCell.h"
#import "UIImageView+AFNetworking.h"

@interface MessageGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelSender;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelSubject;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIView *viewUnreadFlag;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;


@end

@implementation MessageGroupCell

- (void)awakeFromNib {
    self.viewUnreadFlag.backgroundColor = TINT_COLOR;
    self.viewUnreadFlag.clipsToBounds = YES;
    self.viewUnreadFlag.layer.cornerRadius = self.viewUnreadFlag.frame.size.width/2;
    self.viewUnreadFlag.layer.borderWidth = 1;
    self.viewUnreadFlag.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellData:(NSDictionary*)cellData {
    self.viewUnreadFlag.hidden = [cellData[key_message_unread_flag] intValue] != 1;
    self.labelSender.text = cellData[key_message_shop_name];
    self.labelType.text = cellData[key_message_shop_type];
    self.labelSubject.text = cellData[key_message_subject];
    self.labelText.text = cellData[key_message_text];
    self.labelDate.text = [cellData[key_message_date] substringToIndex:10];
    [self.imageGroup setImageWithURL:[NSURL URLWithString:[cellData[key_shop_pic] stringByRemovingPercentEncoding]]];
}

@end
