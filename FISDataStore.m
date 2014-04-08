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

@interface FISDataStore()

@property (nonatomic) NSMutableArray *stocks;

@end

@implementation FISDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSMutableArray *)stocks
{
    if (!_stocks) {
        _stocks = [NSMutableArray new];
    }
    return _stocks;
}

+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedReposDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReposDataStore = [[FISDataStore alloc] init];
    });
    
    return _sharedReposDataStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
        fetchRequest.fetchBatchSize = 20;
        NSSortDescriptor *fullnameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"symbol" ascending:YES];
        fetchRequest.sortDescriptors = @[fullnameDescriptor];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"fetchResultsCache"];
        
        [self.fetchedResultsController performFetch:nil];
    }
    return self;
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

- (void)fetchStocksFromAPI
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSMutableArray *allStocks = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    
    for (Stock *stock in allStocks) {
        [self.managedObjectContext deleteObject:stock];
    }
    
    ///make api call to get stocks from internet
    [YahooAPIClient searchForStockWithName:@"Symbol" withCompletion:^(NSArray *stockDictionaries) {
        for (NSDictionary *stockDict in stockDictionaries) {
            //convert the api response into location managed objected
            [Stock  stockWithStockSearchDictionary:stockDict Context:self.managedObjectContext];
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
    Stock *stock = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:stock];
}




@end
