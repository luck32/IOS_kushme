//
//  UtilManager.h
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilManager : NSObject

+ (UtilManager*)sharedManager;

+ (BOOL)validateEmail:(NSString*)email;

+ (NSString*)validateResponse:(NSString*)response;

+ (NSArray*)sortShopList:(NSMutableArray*)shopList;

@end
