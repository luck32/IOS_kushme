//
//  AlertManager.h
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

+ (AlertManager*)sharedManager;

- (void)showErrorAlert:(NSString*)errorMessage onVC:(UIViewController*)vc;

@end
