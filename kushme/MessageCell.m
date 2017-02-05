//
//  MessageCell.m
//  kushme
//
//  Created by Nicolas Rostov on 17/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UILabel *labelSubject;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *buttonShop;

@end

@implementation MessageCell

- (void)awakeFromNib {
    self.viewHeader.backgroundColor = TINT_COLOR;
    
    UIImage *image = [[UIImage imageNamed:@"trash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.buttonDelete setImage:image forState:UIControlStateNormal];
    self.buttonDelete.tintColor = [UIColor whiteColor];
    
    self.buttonShop.tintColor = TINT_COLOR;
    self.buttonShop.layer.borderColor = [TINT_COLOR CGColor];
    self.buttonShop.layer.borderWidth = 1;
    self.buttonShop.layer.cornerRadius = 2;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.viewHeader.alpha = 1;
    self.viewHeader.backgroundColor = TINT_COLOR;
}

-(void)setCellData:(NSDictionary*)cellData {
    self.buttonDelete.tag = [cellData[key_message_id] intValue];
    self.buttonShop.tag = [cellData[key_message_shop_id] intValue];
    self.labelSubject.text = cellData[key_message_subject];
    self.labelDate.text = [cellData[key_message_details_date] substringToIndex:10];
    self.labelText.text = cellData[key_message_text];
    [self.labelText sizeToFit];
    CGRect textFrame = self.labelText.frame;
    if(textFrame.size.height < 31) {
        textFrame.size.height = 31;
        self.labelText.frame = textFrame;
    }
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMaxY(self.labelText.frame)+38);
}

@end
