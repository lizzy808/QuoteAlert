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
#import <Parse/Parse.h>


@interface FISAppDelegate ()
@property (strong, nonatomic) FISDataStore *dataStore;

@end

@implementation FISAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
//    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"fHfrDrWTcByvGhL9Ns1mJ0bCoeW6WYWK9DyBJtTn"
                  clientKey:@"EE2PJxX6mT9jfQBFLDI1qgnCwZiaOKyDfpfVw0nB"];
    
    // [Optional] Track statistics around application opens.
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
    
//    // Need to request permissions for notifications
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
//        
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    
//    
//    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
//
//    
//    NSLog(@"Launched in background %d", UIApplicationStateBackground == application.applicationState);
//    
//    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (locationNotification) {
//        // Set icon badge number to zero
//        application.applicationIconBadgeNumber = 0;
//    }
    
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
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor blackColor];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


//UIBackgroundFetch

- (void)                application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"Perfoming background fetchzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
    
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
            NSLog(@"Was successful with BGF");
            // We are supposed to pass a background fetch result back to the OS
            completionHandler(UIBackgroundFetchResultNewData);
        }
        
        else
        {
            NSLog(@"Not successful");
        }
    }];
}


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
    [self.dataStore saveContext];
}



@end
