//
//  PlacesAutocompleteUtilities.m
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import "PlacesAutocompleteUtilities.h"
#import "AppDelegate.h"

@implementation NSArray(FoundationAdditions)

- (id)onlyObject
{
//    return [self count] == 1 ? [self objectAtIndex:0] : nil;
    return [self count] > 0 ? [self objectAtIndex:0] : nil;
}

@end


PlacesAutocompletePlaceType placeTypeFromDictionary(NSDictionary *placeDictionary)
{
    return [[placeDictionary objectForKey:@"types"] containsObject:@"establishment"] ? PlaceTypeEstablishment : PlaceTypeGeocode;
}

NSString* booleanStringForBool(BOOL boolean)
{
    return boolean ? @"true" : @"false";
}

NSString* placeTypeStringForPlaceType(PlacesAutocompletePlaceType type)
{
//    return (type == PlaceTypeGeocode) ? @"geocode" : @"establishment";
    return @"(cities)";
}

BOOL ensureGoogleAPIKey()
{
    BOOL userHasProvidedAPIKey = YES;
    if ([Google_Api_Key isEqualToString:@"YOUR_API_KEY"]) {
        userHasProvidedAPIKey = NO;
        
        NSLog(@"Google API Key Needed");
//        [[AlertManager sharedManager] showErrorAlert:@"Google API Key Needed" onVC:nil];
    }
    return userHasProvidedAPIKey;
}

extern BOOL isEmptyString(NSString *string)
{
    return !string || ![string length];
}