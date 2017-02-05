//
//  ShopAnnotation.m
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopAnnotation.h"

@implementation ShopAnnotation


- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
    
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        
        self.shopInfo = nil;
    }
    return self;
}

- (id)initWithShopInfo:(NSDictionary *)shopInfo
{
    if (self = [super init])
    {
        if (shopInfo)
        {
            self.latitude = [[shopInfo objectForKey:key_shop_lat] doubleValue];
            self.longitude = [[shopInfo objectForKey:key_shop_long] doubleValue];
            
            self.shopInfo = shopInfo;
        }
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.latitude = newCoordinate.latitude;
    self.longitude = newCoordinate.longitude;
}

- (NSString *)title
{
    NSString* title = [self.shopInfo objectForKey:key_shop_name];
    if (!title)
        title = @"";
    return title;
}

- (NSString *)subtitle
{
    return [self.shopInfo objectForKey:key_shop_decription];
}


@end
