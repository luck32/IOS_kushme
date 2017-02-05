//
//  DealTableViewCell.m
//  kushme
//
//  Created by Nicolas Rostov on 15/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "DealTableViewCell.h"

@interface DealTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelDealName;
@property (weak, nonatomic) IBOutlet UILabel *labelDealDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelDealDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonDealDetails;

@end

@implementation DealTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.buttonDealDetails.clipsToBounds = YES;
    self.buttonDealDetails.layer.cornerRadius = 4;
    self.buttonDealDetails.layer.borderWidth = 1;
    self.buttonDealDetails.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (void)setCellData:(NSDictionary*)cellData {
    self.labelDealName.text = [UtilManager validateResponse:cellData[key_shop_name]];
    self.labelDealDescription.text = [UtilManager validateResponse:cellData[key_deal_name]];
    self.labelDealDate.text = [UtilManager validateResponse:cellData[key_deal_end_date]];
}

- (void)setDetailsTarget:(id)target action:(SEL)action tag:(NSInteger)tag {
    self.buttonDealDetails.tag = tag;
    [self.buttonDealDetails addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
