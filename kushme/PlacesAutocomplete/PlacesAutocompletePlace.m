//
//  PlacesAutocompletePlace.m
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import "PlacesAutocompletePlace.h"
#import "PlacesPlaceDetailQuery.h"

@interface PlacesAutocompletePlace()

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *reference;
@property (nonatomic, retain, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) NSString *placeId;
@property (nonatomic, retain, readwrite) NSDictionary* placeDict;
@property (nonatomic, readwrite) PlacesAutocompletePlaceType type;

@end


@implementation PlacesAutocompletePlace

@synthesize name, reference, identifier, placeId, placeDict, type;

+ (PlacesAutocompletePlace *)placeFromDictionary:(NSDictionary *)placeDictionary
{
    PlacesAutocompletePlace* place = [[self alloc] init];
    place.name = [placeDictionary objectForKey:@"description"];
    place.reference = [placeDictionary objectForKey:@"reference"];
    place.identifier = [placeDictionary objectForKey:@"id"];
    place.placeId = [placeDictionary objectForKey:@"place_id"];
    place.type = placeTypeFromDictionary(placeDictionary);
    place.placeDict = placeDictionary;
    return place;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@, Reference: %@, Identifier: %@, placeId: %@, placeDict: %@, Type: %@",
            name, reference, identifier, placeId, placeDict, placeTypeStringForPlaceType(type)];
}

- (CLGeocoder *)geocoder
{
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    return geocoder;
}

- (void)resolveEstablishmentPlaceToPlacemark:(PlacesPlacemarkResultBlock)block
{
    PlacesPlaceDetailQuery* query = [PlacesPlaceDetailQuery query];
    query.reference = self.reference;
    [query fetchPlaceDetail:^(NSDictionary *placeDictionary, NSError *error) {
        if (error) {
            block(nil, nil, error);
        } else {
            NSString* addressString = [placeDictionary objectForKey:@"formatted_address"];
            [[self geocoder] geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error) {
                    block(nil, nil, error);
                } else {
                    CLPlacemark* placemark = [placemarks onlyObject];
                    block(placemark, self.name, error);
                }
            }];
        }
    }];
}

- (void)resolveGecodePlaceToPlacemark:(PlacesPlacemarkResultBlock)block
{
    [[self geocoder] geocodeAddressString:self.name completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            block(nil, nil, error);
        } else {
            CLPlacemark* placemark = [placemarks onlyObject];
            block(placemark, self.name, error);
        }
    }];
}

- (void)resolveToPlacemark:(PlacesPlacemarkResultBlock)block
{
    if (type == PlaceTypeGeocode) {
        // Geocode places already have their address stored in the 'name' field.
        [self resolveGecodePlaceToPlacemark:block];
    } else {
        [self resolveEstablishmentPlaceToPlacemark:block];
    }
}

- (void)resolveToPlaceDictionary:(PlacesPlaceDetailResultBlock)block {
    
    PlacesPlaceDetailQuery* query = [PlacesPlaceDetailQuery query];
    query.reference = self.reference;
    [query fetchPlaceDetail:^(NSDictionary *placeDictionary, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            block(placeDictionary, error);
        }
    }];
}


@end
