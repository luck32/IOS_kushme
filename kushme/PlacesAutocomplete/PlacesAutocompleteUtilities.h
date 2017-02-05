//
//  PlacesAutocompleteUtilities.h
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#define kGoogleAPINSErrorCode 42

@class CLPlacemark;

typedef enum {
    PlaceTypeGeocode = 0,
    PlaceTypeEstablishment
} PlacesAutocompletePlaceType;

typedef void (^PlacesPlacemarkResultBlock)(CLPlacemark *placemark, NSString *addressString, NSError *error);
typedef void (^PlacesAutocompleteResultBlock)(NSArray *places, NSError *error);
typedef void (^PlacesPlaceDetailResultBlock)(NSDictionary *placeDictionary, NSError *error);

extern PlacesAutocompletePlaceType placeTypeFromDictionary(NSDictionary *placeDictionary);
extern NSString *booleanStringForBool(BOOL boolean);
extern NSString *placeTypeStringForPlaceType(PlacesAutocompletePlaceType type);
extern BOOL ensureGoogleAPIKey();
extern BOOL isEmptyString(NSString *string);

@interface NSArray(FoundationAdditions)

- (id)onlyObject;

@end