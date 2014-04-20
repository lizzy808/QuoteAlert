//
//  FISDataStore.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/26/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISDataStore.h"
#import "YahooAPIClient.h"
#import "Stock+Methods.h"
#import <CoreData/CoreData.h>

@interface FISDataStore()

@property (nonatomic) NSMutableArray *stocks;
@property (nonatomic) NSMutableArray *stockDetails;
@property (strong,nonatomic) YahooAPIClient *yahooAPIClient;

@end

@implementation FISDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchedStockResultsController = _fetchedStockResultsController;

- (NSMutableArray *)stocks
{
    if (!_stocks) {
        _stocks = [NSMutableArray new];
    }
    return _stocks;
}

- (NSMutableArray *)stockDetails
{
    if (!_stockDetails) {
        _stockDetails = [NSMutableArray new];
    }
    return _stockDetails;
}

+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedReposDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReposDataStore = [[FISDataStore alloc] init];
    });
    if (_sharedReposDataStore) {
        _sharedReposDataStore.yahooAPIClient = [[YahooAPIClient alloc]init];
    }
    return _sharedReposDataStore;
}


- (NSFetchedResultsController *)fetchedStockResultsController
{
    if (!_fetchedStockResultsController)
    {
        NSFetchRequest *stockFetch = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
        stockFetch.fetchBatchSize = 10;
        
        stockFetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES]];
        
        _fetchedStockResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:stockFetch managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"fetchedResultsCache"];
              
        [_fetchedStockResultsController performFetch:nil];
    }
    return _fetchedStockResultsController;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Quote_Alert" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Quote_Alert.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//- (void)fetchStocksWithName:(NSString *)symbolName
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
//    NSMutableArray *allStocks = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
//    
//    for (Stock *stock in allStocks) {
//        [self.managedObjectContext deleteObject:stock];
//    }
//    
//    ///make api call to get stocks from internet
//    [YahooAPIClient searchForStockWithName:symbolName withCompletion:^(NSArray *stockDictionaries) {
//        for (NSDictionary *stockDict in stockDictionaries) {
//            //convert the api response into location managed objected
//            [Stock  stockWithStockSearchDictionary:stockDict Context:self.managedObjectContext];
//        }
//    }];
//}

- (void)addStockDetailsWithSymbol:(NSString *)symbolName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    NSMutableArray *allStocks = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    
    for (Stock *stock in allStocks) {
        [self.managedObjectContext deleteObject:stock];
    }
    [YahooAPIClient searchForStockDetails:symbolName withCompletion:^(NSDictionary *detailDictionaries) {
        NSMutableArray *coreDataStocks = [NSMutableArray new];
        for (NSDictionary *detailDict in detailDictionaries) {
            [Stock stockWithStockDetailDictionary:detailDict Context:self.managedObjectContext];
            [coreDataStocks addObject:[Stock stockWithStockDetailDictionary:detailDict Context:self.managedObjectContext]];
        }
    }];
}

- (void)addStock:(id)stock
{
    [self.stocks addObject:stock];
}

- (BOOL)removeStock:(Stock *)stock
{
    if ([self.stocks containsObject:stock]) {
        [self.stocks removeObject:stock];
        return YES;
    }
    return NO;
}


- (void)deleteStockAtIndexPay:(NSIndexPath *)indexPath
{
    Stock *stock = [self.fetchedStockResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:stock];
}




@end
