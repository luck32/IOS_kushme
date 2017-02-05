//
//  ShopTableViewCell.m
//  kushme
//
//  Created by Nicolas Rostov on 14/5/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ShopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopPicture;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;

@end

@implementation ShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(NSDictionary*)cellData {
    self.shopName.text = cellData[key_shop_name];
    [self.shopName sizeToFit];
    self.shopAddress.text = [NSString stringWithFormat:@"%@, %@, %@", cellData[key_shop_address], cellData[key_shop_city], cellData[key_shop_zip]];
    NSString *picUrlString = [cellData[key_shop_pic] stringByRemovingPercentEncoding];
    [self.shopPicture setImageWithURL:[NSURL URLWithString:picUrlString]];
}

@end
