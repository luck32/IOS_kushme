//
//  PlacesAutocompleteQuery.h
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "PlacesAutocompleteUtilities.h"

@interface PlacesAutocompleteQuery : NSObject
{
    NSURLConnection* googleConnection;
    NSMutableData* responseData;
}

@property (nonatomic, copy, readonly) PlacesAutocompleteResultBlock resultBlock;

+ (PlacesAutocompleteQuery*)query;

- (void)fetchPlaces:(PlacesAutocompleteResultBlock)block;

#pragma mark -
#pragma mark Required parameters

@property (nonatomic, retain) NSString* input;

@property (nonatomic) BOOL sensor;

#pragma mark -
#pragma mark Optional parameters

@property (nonatomic) NSUInteger offset;

@property (nonatomic) CLLocationCoordinate2D location;

@property (nonatomic) CGFloat radius;

@property (nonatomic, retain) NSString* language;

@property (nonatomic) PlacesAutocompletePlaceType types;

@end