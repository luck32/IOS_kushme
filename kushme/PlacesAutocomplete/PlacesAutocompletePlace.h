//
//  PlacesAutocompletePlace.h
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "PlacesAutocompleteUtilities.h"

@interface PlacesAutocompletePlace : NSObject
{
    CLGeocoder *geocoder;
}

+ (PlacesAutocompletePlace *)placeFromDictionary:(NSDictionary *)placeDictionary;

@property (nonatomic, retain, readonly) NSString* name;

@property (nonatomic, readonly) PlacesAutocompletePlaceType type;

@property (nonatomic, retain, readonly) NSString* reference;

@property (nonatomic, retain, readonly) NSString* identifier;

@property (nonatomic, retain, readonly) NSString* placeId;

@property (nonatomic, retain, readonly) NSDictionary* placeDict;

- (void)resolveToPlacemark:(PlacesPlacemarkResultBlock)block;

- (void)resolveToPlaceDictionary:(PlacesPlaceDetailResultBlock)block;

@end