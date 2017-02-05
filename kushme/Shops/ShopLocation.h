//
//  ShopLocation.h
//  kushme
//
//  Created by PARTHA on 26/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ShopLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
