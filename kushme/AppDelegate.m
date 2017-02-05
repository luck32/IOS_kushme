//
//  AppDelegate.m
//  kushme
//
//  Created by Paras Gorasiya on 11/05/15.
//  Copyright (c) 2015 Paras Gorasiya. All rights reserved.
//

#import "AppDelegate.h"
#import "APIManager.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.tintColor = TINT_COLOR;

    UITabBarController *mainTabBar = (UITabBarController*)self.window.rootViewController;
    mainTabBar.delegate = self;
    
    [self updateMessagesNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessagesNotifications) name:Notification_UserLoginStateChanged object:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self updateMessagesNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark InboxMessagesNotifications
-(void)updateMessagesNotifications {
    UITabBarController *mainTabBar = (UITabBarController*)self.window.rootViewController;
    UITabBarItem *messagesItem = [mainTabBar.tabBar.items lastObject];
    if([[APIManager sharedManager] isUserLoggedIn]) {
        [[APIManager sharedManager] getNumberOfUnreadMessages:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([responseObject[@"no_of_unread"] intValue] > 0)
                messagesItem.badgeValue = [NSString stringWithFormat:@"%@", responseObject[@"no_of_unread"]];
            else
                messagesItem.badgeValue = nil;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    else {
        messagesItem.badgeValue = nil;   
    }
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController *navigationContoller;
    if([viewController isKindOfClass:[UINavigationController class]])
        navigationContoller = (UINavigationController*)viewController;
    [navigationContoller popToRootViewControllerAnimated:NO];
}

@end
