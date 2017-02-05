//
//  PlacesPlaceDetailQuery.h
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlacesAutocompleteUtilities.h"

@interface PlacesPlaceDetailQuery : NSObject
{
    NSURLConnection* googleConnection;
    NSMutableData* responseData;
}

@property (nonatomic, copy, readonly) PlacesPlaceDetailResultBlock resultBlock;

+ (PlacesPlaceDetailQuery *)query;

- (void)fetchPlaceDetail:(PlacesPlaceDetailResultBlock)block;

#pragma mark -
#pragma mark Required parameters

@property (nonatomic, retain) NSString *reference;

@property (nonatomic) BOOL sensor;

#pragma mark -
#pragma mark Optional parameters

@property (nonatomic, retain) NSString *language;

@end
