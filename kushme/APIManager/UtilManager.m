//
//  UtilManager.m
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "UtilManager.h"

@implementation UtilManager

+ (UtilManager*)sharedManager {
    
    static UtilManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (BOOL)validateEmail:(NSString*)email {
    
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (NSString*)validateResponse:(NSString*)response {
    
    if (response == nil || [response isKindOfClass:[NSNull class]])
        return @"";
    
    return response;
}

+ (NSArray*)sortShopList:(NSMutableArray*)shopList {
    
    NSArray* sortedShopList = nil;
    if (shopList) {
        sortedShopList = [shopList sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
            if(![obj1[key_distance] isKindOfClass:[NSNumber class]] || ![obj2[key_distance] isKindOfClass:[NSNumber class]])
                return NSOrderedSame;
            if ([obj1[key_distance] intValue] < [obj2[key_distance] intValue]) {
                return NSOrderedAscending;
            }
            else if ([obj1[key_distance] intValue] == [obj2[key_distance] intValue]) {
                if ([obj1[key_shop_rating] intValue] > [obj2[key_shop_rating] intValue])
                    return NSOrderedAscending;
                else if ([obj1[key_shop_rating] intValue] == [obj2[key_shop_rating] intValue]) {
                    if (obj1[key_shop_name] < obj2[key_shop_name])
                        return NSOrderedAscending;
                }
            }
            return NSOrderedDescending;
        }];
    }
    
    return sortedShopList;
}

@end
