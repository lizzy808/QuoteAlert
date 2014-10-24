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
#import "FISStockDetailViewController.h"

@interface FISAppDelegate ()
@property (strong, nonatomic) FISDataStore *dataStore;

@end

@implementation FISAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    
    // Need to request permissions for notifications
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }


    
    
    
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    

    NSLog(@"Launched in background %d", UIApplicationStateBackground == application.applicationState);

    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
   
    }
    
//    UILocalNotification *notification = [UILocalNotification new];
//    notification.alertBody = @"Your stock price is dropping!";
//    [application presentLocalNotificationNow:notification];
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quote Alert"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}


//////////////UIBackgroundFetch/////////////////


- (void)                application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"Perfoming fetch");
    
    //[YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
    
    [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:YES WithCompletion:^(BOOL isSuccessful) {
            
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
//    [[FISStockDetailViewController alertNotification] setHidden:YES];
    [self.dataStore saveContext];
}



@end
