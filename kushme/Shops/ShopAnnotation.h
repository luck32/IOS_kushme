//
//  ShopAnnotation.h
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAnnotation : NSObject <MKAnnotation>

@property (nonatomic) int tag;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

@property (strong, nonatomic) NSDictionary* shopInfo;


- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
- (id)initWithShopInfo:(NSDictionary*)shopInfo;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;


@end
