//
//  LocationManager.m
//  kushme
//
//  Created by Yanny on 5/14/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager


+ (LocationManager*)sharedManager {
    
    static LocationManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)initCurrentLocation
{
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone; //kCLDistanceFilterNone// kDistanceFilter;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}


#pragma mark -
#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    self.userLocation = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserLocationUpdated object:self];
    
#if DEBUG
//    NSLog(@"=====> New Location = (%f, %f)",
//          self.userLocation.coordinate.latitude,
//          self.userLocation.coordinate.longitude);
#endif
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    
#if DEBUG
    NSLog(@"=====> User Location Failed : %@", error.localizedDescription);
#endif
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
#if DEBUG
    NSString* strStatus = @"NotDetermined";
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            strStatus = @"NotDetermined"; break;
        case kCLAuthorizationStatusRestricted:
            strStatus = @"Restricted"; break;
        case kCLAuthorizationStatusDenied:
            strStatus = @"Denied"; break;
        case kCLAuthorizationStatusAuthorizedAlways:
            strStatus = @"AuthorizedAlways"; break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            strStatus = @"AuthorizedWhenInUse"; break;
            
        default:
            break;
    }
    NSLog(@"=====> User didChangeAuthorizationStatus : %d (%@)", status, strStatus);
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LocationAuthorizationStatusChanged object:[NSNumber numberWithInt:status]];
}


@end
