//
//  FISAppDelegate.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/24/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISAppDelegate.h"
#import "FISDataStore.h"
#import "YahooAPIClient.h"
#import "Stock+Methods.h"
#import "FISDataStore.h"

@interface FISAppDelegate ()
@property (strong, nonatomic) FISDataStore *dataStore;

@end

@implementation FISAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    UILocalNotification *notification = [UILocalNotification new];
    //notification.fireDate
    notification.alertBody = @"%@",
    
    [application presentLocalNotificationNow:notification];
    
    return YES;
}

//////////////UIBackgroundFetch/////////////////

//- (void)                application:(UIApplication *)application
//  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    
//    NSURL *url = [[NSURL alloc] initWithString:@"http://yourserver.com/data.json"];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:url
//                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                            
//                                            if (error) {
//                                                completionHandler(UIBackgroundFetchResultFailed);
//                                                return;
//                                            }
//                                            
//                                            // Parse response/data and determine whether new content was available
//                                            BOOL hasNewData = ...
//                                            if (hasNewData) {
//                                                completionHandler(UIBackgroundFetchResultNewData);
//                                            } else {
//                                                completionHandler(UIBackgroundFetchResultNoData);
//                                            };
//                                        }];
//    // Start the task
//    [task resume];
//}

//- (void)           application:(UIApplication *)application
//  didReceiveRemoteNotification:(NSDictionary *)userInfo
//        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    NSLog(@"Remote Notification userInfo is %@", userInfo);
//    
//    NSNumber *contentID = userInfo[@"content-id"];
//    // Do something with the content ID
//    completionHandler(UIBackgroundFetchResultNewData);
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.dataStore saveContext];
    // Saves changes in the application's managed object context before the application terminates.
}

//- (void)initialSetup
//{
//    self.dataStore = [FISDataStore sharedDataStore];
//    [self.dataStore createInitialData];
//}

@end
