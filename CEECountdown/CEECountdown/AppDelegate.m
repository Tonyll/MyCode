//
//  AppDelegate.m
//  CEECountdown
//
//  Created by Tony L on 7/6/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "AppDelegate.h"
#import "CEETabBarController.h"
#import "CEENetWork.h"
#import <MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self umengRegist];
    CEETabBarController *tabbar = [[CEETabBarController alloc] init];
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    if (!LOCAL_GET_USERCONFIG) {
        [[CEENetWork sharedManager] requestWithMethod:POST WithPath:URL_LOGIN_GETCONFIG WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
            if ([[dic objectForKey:@"errorcode"] integerValue] != 0) {
                
                return;
            }
            LOCAL_SET_USERCONFIG(YES);
            LOCAL_SYNCHRONIZE;
            
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }
    return YES;
}

-(void)umengRegist
{
    [MobClick startWithAppkey:UMengAppKey reportPolicy:BATCH channelId:@""];
    [MobClick setEncryptEnabled:YES];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick updateOnlineConfig];
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
