//
//  FISDataStore.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/26/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stock+Methods.h"

@interface FISDataStore : NSObject

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

+ (instancetype) sharedDataStore;

- (void)fetchStocksFromAPI;

- (void)addStock:(Stock *)stock;

//- (void)deleteStockAtIndexPath:(NSIndexPath *)indexPath;

@end
