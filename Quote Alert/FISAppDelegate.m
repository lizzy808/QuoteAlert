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
#import "FISMainViewController.h"

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


    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    

    NSLog(@"Launched in background %d", UIApplicationStateBackground == application.applicationState);

    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
   
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
    }
    
//    UILocalNotification *notification = [UILocalNotification new];
//    notification.alertBody = @"Your stock price is dropping!";
//    [application presentLocalNotificationNow:notification];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
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
    
    NSLog(@"Perfoming background fetch");
    
    //[YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
    
    
    
    
    // Determine if default for areAlertsMuted is set
    BOOL shouldFireNotification;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"areAlertsMuted"])
    {
        
        if([defaults boolForKey:@"areAlertsMuted"])
            shouldFireNotification = NO;
        else
            shouldFireNotification = YES;
    }
    else
    {
        // Default hasn't been set yet so it definitely isn't muted
        shouldFireNotification = YES;
    }
    
    if (shouldFireNotification)
        NSLog(@"Should Fire Notification");
    else
        NSLog(@"Notification shouldn't fire because it is muted");
    
    
    
    // Fetch the background results
    [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:shouldFireNotification WithCompletion:^(BOOL isSuccessful) {
            
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
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    [[FISStockDetailViewController alertNotification] setHidden:YES];
    [self.dataStore saveContext];
}



@end
