//
//  FISAppDelegate.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/24/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Stock+Methods.h"

@interface FISAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) Stock *stock;

@end
