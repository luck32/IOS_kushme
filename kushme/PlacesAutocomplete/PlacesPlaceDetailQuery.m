//
//  PlacesPlaceDetailQuery.m
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import "PlacesPlaceDetailQuery.h"

@interface PlacesPlaceDetailQuery()

@property (nonatomic, copy, readwrite) PlacesPlaceDetailResultBlock resultBlock;

@end


@implementation PlacesPlaceDetailQuery

@synthesize reference, sensor, language, resultBlock;

+ (PlacesPlaceDetailQuery *)query
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}

- (NSString *)googleURLString
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=%@&key=%@", reference, booleanStringForBool(sensor), Google_Api_Key];
    if (language) {
        [url appendFormat:@"&language=%@", language];
    }
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

- (void)fetchPlaceDetail:(PlacesPlaceDetailResultBlock)block
{
    if (!ensureGoogleAPIKey()) {
        return;
    }
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
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

- (void)succeedWithPlace:(NSDictionary *)placeDictionary
{
    if (self.resultBlock != nil) {
        self.resultBlock(placeDictionary, nil);
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
        NSError* error = nil;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlace:[response objectForKey:@"result"]];
        }
        
        // Must have received a status of UNKNOWN_ERROR, ZERO_RESULTS, OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
        [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}

@end
