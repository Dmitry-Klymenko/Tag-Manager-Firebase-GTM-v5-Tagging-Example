//
//  AppDelegate.m
//  testGTMv5iOS
//
//  Created by Dmitry Klymenko on 27/6/19.
//  Copyright © 2019 Dmitry Klymenko. All rights reserved.
//

#import "AppDelegate.h"
#import "AnalyticsManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AnalyticsManager instance] initializeAnalytics];
    
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(url) {
        [self handleOpenURL:url];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[AnalyticsManager instance] appEnterForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
        handleEventsForBackgroundURLSession:(NSString *)identifier
                          completionHandler:(void (^)(void))completionHandler {
    
    [[AnalyticsManager instance] handleEventsForBackgroundURLSession:identifier
                                                   completionHandler:completionHandler
     ];
    
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [self handleOpenURL:url];
    
    return YES;
}

- (void)handleOpenURL:(nonnull NSURL *)url {
    
    //send Custom Analytics Campaigns
    [[AnalyticsManager instance] registerCampaign:@"campaign1" source:@"source1" medium:@"medium1"];
    
    [[AnalyticsManager instance] handleOpenURL:url];
    
}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    
    [[AnalyticsManager instance] handleUserActivity:userActivity];
    
}

@end
