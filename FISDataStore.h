//
//  FISDataStore.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/26/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISDataStore : NSObject

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (instancetype) sharedDataStore;

@end
