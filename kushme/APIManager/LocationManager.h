//
//  LocationManager.h
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* userLocation;

+ (LocationManager*)sharedManager;

- (instancetype)init;

- (void)initCurrentLocation;

@end
