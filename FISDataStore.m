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
#import <Parse/Parse.h>

@interface FISDataStore()

@property (nonatomic) NSMutableArray *stocks;
@property (nonatomic) NSMutableArray *stockDetails;
@property (strong,nonatomic) YahooAPIClient *yahooAPIClient;
@property (strong, nonatomic) NSDictionary *stockDict;


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

- (NSString *)searchSymbol
{
    if (!_searchSymbol) {
        _searchSymbol = [NSString new];
    }
    return _searchSymbol;
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
        
        _fetchedStockResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:stockFetch managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        
        [_fetchedStockResultsController performFetch:nil];
    }
    return _fetchedStockResultsController;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
//    PFObject *stockObject = [PFObject objectWithClassName:@"StockAlerts"];
//    stockObject[@"symbol"] = self.stockDict[@"symbol"];
//    
//    //        StockAlerts[@"userAlertPriceHigh"] = repository.userAlertPriceHigh;
//    //        StockAlerts[@"userAlertPriceLow"] = repository.userAlertPriceLow;
//    
//    [stockObject saveInBackground];

    
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//NSURLSession *session = [NSURLSession sharedSession];
//[[session dataTaskWithURL:[NSURL URLWithString:yahooDetailURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    
//    if (error)
//    {
//        NSLog(@"searchForStockDetails ERROR: %@", error.localizedDescription);
//        //completion(nil);
//    }
//    else
//    {
//        NSString *newString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"searchForStockDetails %@", newString);
//        
//        NSDictionary *stockDetailDictionary = [NSJSONSerialization JSONObjectWithData:[newString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        
//        // Check to make sure the element exists before assigning to a dictionary
//        if (stockDetailDictionary[@"query"][@"count"])
//        {
//            NSNumber *resultCount = stockDetailDictionary[@"query"][@"count"];
//            
//            if (resultCount.integerValue > 0)
//            {
//                NSDictionary *stockQuoteDictionary = stockDetailDictionary [@"query"][@"results"][@"quote"];
//                completion(stockQuoteDictionary);
//            }
//            else
//            {
//                NSLog(@"searchForStockDetails ERROR: No results for quote on %@", escapedSymbol);
//                //completion(nil);
//            }
//            
//        }
//        else
//        {
//            NSLog(@"searchForStockDetails ERROR: Missing value for quote on %@", escapedSymbol);
//            //completion(nil);
//        }
//        
//        
//        
//        
//    }
//}] resume];
//}


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


- (void)addStockDetailsWithSymbol:(NSString *)symbolName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Stock"];
    NSMutableArray *allStocks = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    
    for (Stock *stock in allStocks) {
        [self.managedObjectContext deleteObject:stock];
    }
    [YahooAPIClient searchForStockDetails:self.searchSymbol withCompletion:^(NSDictionary *detailDictionaries) {
        NSMutableArray *coreDataStocks = [NSMutableArray new];
        for (NSDictionary *detailDict in detailDictionaries)
        {
            [Stock stockWithStockDetailDictionary:detailDict Context:self.managedObjectContext];
            [coreDataStocks addObject:[Stock stockWithStockDetailDictionary:detailDict Context:self.managedObjectContext]];
        }
    }];
}


- (void)refreshUserStocks:(NSMutableArray *)symbols
{
    for (Stock *stock in self.stocks) {
        [self.managedObjectContext deleteObject:stock];
    }
    [YahooAPIClient searchForStockDetails:self.searchSymbol withCompletion:^(NSDictionary *detailDictionaries) {
        NSMutableArray *coreDataStocks = [NSMutableArray new];
        for (NSDictionary *detailDict in detailDictionaries)
        {
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"StockAlerts"];
    
    NSString *currentInstallationId;
    PFInstallation *installation = [PFInstallation currentInstallation];
    currentInstallationId = installation[@"installationId"];
    
    [query whereKey:@"installationId" equalTo:currentInstallationId];
    [query whereKey:@"symbol" equalTo:stock.symbol];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *stockAlerts, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)stockAlerts.count);
            // Do something with the found objects
            for (PFObject *stockAlert in stockAlerts)
            {
                NSLog(@"%@", stockAlert.objectId);
                
                [stockAlert deleteInBackground];
                
                //                [stockAlert delete];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self.managedObjectContext deleteObject:stock];

}

+ (void)changeParseNotifcationEnabledTo:(BOOL)enabled
{
    PFQuery *query = [PFQuery queryWithClassName:@"StockAlerts"];
    
    NSString *currentInstallationId;
    PFInstallation *installation = [PFInstallation currentInstallation];
    currentInstallationId = installation[@"installationId"];
    
    [query whereKey:@"installationId" equalTo:currentInstallationId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *stockAlerts, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)stockAlerts.count);
            // Do something with the found objects
            for (PFObject *stockAlert in stockAlerts)
            {
                NSLog(@"%@", stockAlert.objectId);
                
                stockAlert[@"alertNotificationEnabled"] = [NSNumber numberWithBool:enabled];
                
                [stockAlert saveInBackground];
//                [stockAlert fetch];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}



@end
