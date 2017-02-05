//
//  ShopLocation.m
//  kushme
//
//  Created by PARTHA on 26/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "ShopLocation.h"

@interface ShopLocation()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation ShopLocation

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.address = address;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return _name;
}

- (NSString *)subtitle
{
    return _address;
}

- (CLLocationCoordinate2D)coordinate

{
    return _theCoordinate;
}

- (MKMapItem*)mapItem

{
  
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate addressDictionary:_address];
                              
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}


@end

