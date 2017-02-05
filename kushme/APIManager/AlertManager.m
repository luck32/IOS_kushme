//
//  AlertManager.m
//  kushme
//
//  Created by Yanny on 5/13/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager


+ (AlertManager*)sharedManager {
    
    static AlertManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)showErrorAlert:(NSString*)errorMessage onVC:(UIViewController*)vc {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"kushme" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
