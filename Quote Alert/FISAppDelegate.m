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
    
    NSLog(@"Launched in background %d", UIApplicationStateBackground == application.applicationState);

    
//    UILocalNotification *notification = [UILocalNotification new];
//    notification.alertBody = @"Your stock price is dropping!";
//    [application presentLocalNotificationNow:notification];
    
    return YES;
}

//////////////UIBackgroundFetch/////////////////


- (void)                application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"Perfoming fetch");
    
    [YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
        
        if (isSuccessful)
        {
            NSLog(@"Was successful");
            // We are supposed to pass a background fetch result back to the OS
            completionHandler(UIBackgroundFetchResultNewData);
        }
        
        else
        {
            NSLog(@"Not successful");
        }
    }];
    
    
    
    
//    
//    
//    
//    
//    [YahooAPIClient searchForStockDetails:@"TSLA" withCompletion:^(NSDictionary *stockDictionary)
//    
//    {
////        [Stock stockWithStockDetailDictionary:stockDictionary Context:self.dataStore.managedObjectContext];
////        [self.dataStore saveContext];
//        
////        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
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
    
    // Start the task
//    [task resume];
}


/*
- (void)           application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Remote Notification userInfo is %@", userInfo);
    
    NSNumber *contentID = userInfo[@"content-id"];
    // Do something with the content ID
    completionHandler(UIBackgroundFetchResultNewData);
}
*/
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnteredForeground"
                                                        object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.dataStore saveContext];
}



@end
