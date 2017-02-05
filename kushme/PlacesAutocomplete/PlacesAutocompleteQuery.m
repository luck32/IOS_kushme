//
//  PlacesAutocompleteQuery.m
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import "PlacesAutocompleteQuery.h"
#import "PlacesAutocompletePlace.h"

@interface PlacesAutocompleteQuery()

@property (nonatomic, copy, readwrite) PlacesAutocompleteResultBlock resultBlock;

@end


@implementation PlacesAutocompleteQuery

@synthesize input, sensor, offset, location, radius, language, types, resultBlock;

+ (PlacesAutocompleteQuery *)query
{
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.offset = NSNotFound;
        self.location = CLLocationCoordinate2DMake(-1, -1);
        self.radius = NSNotFound;
        self.types = -1;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}

- (NSString *)googleURLString
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=%@&key=%@",
                            [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            booleanStringForBool(sensor), Google_Api_Key];
    if (offset != NSNotFound) {
        [url appendFormat:@"&offset=%lu", (unsigned long)offset];
    }
    if (location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", location.latitude, location.longitude];
    }
    if (radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", radius];
    }
    if (language) {
        [url appendFormat:@"&language=%@", language];
    }
//    if (types != -1) {
//        [url appendFormat:@"&types=%@", placeTypeStringForPlaceType(types)];
        [url appendFormat:@"&types=%@", placeTypeStringForPlaceType(types)];
//    }
    return url;
}

- (void)cleanup
{
    googleConnection = nil;
    responseData = nil;
    
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests
{
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchPlaces:(PlacesAutocompleteResultBlock)block
{
    if (!ensureGoogleAPIKey()) {
        return;
    }
    
    if (isEmptyString(self.input)) {
        // Empty input string. Don't even bother hitting Google.
        block([NSArray array], nil);
        return;
    }
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    [request setValue:GoogleSearch_RefererURL forHTTPHeaderField:key_Referer];
    googleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error
{
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlaces:(NSArray *)places
{
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    for (NSDictionary *place in places) {
        [parsedPlaces addObject:[PlacesAutocompletePlace placeFromDictionary:place]];
    }
    if (self.resultBlock != nil) {
        self.resultBlock(parsedPlaces, nil);
    }
    [self cleanup];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == googleConnection) {
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data
{
    if (connnection == googleConnection) {
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection == googleConnection) {
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == googleConnection) {
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:[NSArray array]];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlaces:[response objectForKey:@"predictions"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
        [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}

@end