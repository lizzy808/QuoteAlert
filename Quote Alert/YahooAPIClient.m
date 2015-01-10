//
//  YahooAPIClient.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/25/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "YahooAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "FISDataStore.h"
#import "Stock.h"
#import "FISMainViewController.h"
#import "FISMainTableViewCell.h"

@interface YahooAPIClient()

@property (nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) FISDataStore *dataStore;

@end

@implementation YahooAPIClient



- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        _dataStore = [FISDataStore sharedDataStore];
    }
    return _sessionManager;
}


// API Call with stock symbol, parse JSON and pass selected symbol to stock detail search

+ (void)searchForStockWithName:(NSString *)name withCompletion:(void (^)(NSArray *stockDictionaries))completion{
    
    NSString *yahooURLString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback", name];
    
    NSLog(@"URL = %@", yahooURLString);
    
    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:[NSURL URLWithString:yahooURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (response)
        {
            NSString *newString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *cleanJSON = [newString substringFromIndex:39];
            cleanJSON = [cleanJSON substringToIndex:[cleanJSON length]-1];
            
            NSData *parsedData = [cleanJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *stockDictionary = [NSJSONSerialization JSONObjectWithData:parsedData options:NSJSONReadingAllowFragments error:nil];
            NSArray *results = stockDictionary [@"ResultSet"][@"Result"];
            
            completion(results);
        }
        else
        {
            NSLog(@"No response detected");
        }
    }] resume];
}


+ (void)searchForStockDetails:(NSString *)symbol withCompletion:(void (^)(NSDictionary *))completion
{
    
    // Escape special characters in the symbol name i.e. ^NYA in order to sanitize them for placement in the URL
    NSString *escapedSymbol = [symbol stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    
    NSString *yahooDetailURLString = @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22";
    yahooDetailURLString = [yahooDetailURLString stringByAppendingString:escapedSymbol];
    yahooDetailURLString = [yahooDetailURLString stringByAppendingString:@"%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="];
    
    NSLog(@"SearchForStockDetails URL = %@",yahooDetailURLString );
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:yahooDetailURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error)
        {
            NSLog(@"searchForStockDetails ERROR: %@", error.localizedDescription);
        }
        else
        {
            NSString *newString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            //NSLog(@"searchForStockDetails %@", newString);
            
            NSDictionary *stockDetailDictionary = [NSJSONSerialization JSONObjectWithData:[newString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *stockQuoteDictionary = stockDetailDictionary [@"query"][@"results"][@"quote"];
            
            completion(stockQuoteDictionary);
        }
    }] resume];
}



// Method to loop through all user stocks from the datastore and update them. Passes a simple boolean YES if complete

+ (void)fetchAllUserStocksUpdatesShouldFireNotification: (BOOL)notification WithCompletion:(void (^)(BOOL))completed; 
{
    
    //
    // Since we need to access these vars from within the block we need to add __block to them
    // For more documentation see https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/Blocks/Articles/bxVariables.html
    //
    
    __block int totalStocks;                        // Show the total number of stocks to get
    __block int stockResultsReceived = 0;           // Counter for how many results we have received
    
    // Get the total number of stocks we are expecting
    totalStocks = (int)[[FISDataStore sharedDataStore].fetchedStockResultsController fetchedObjects].count;
    
    // Enumerate (loop) through all the stocks in the datastore
    for (Stock *stock in [[FISDataStore sharedDataStore].fetchedStockResultsController fetchedObjects])
    {
        NSLog(@"Attempting to refresh %@ with previous bidprice = %@", stock.symbol, stock.bidPrice);

        [YahooAPIClient searchForStockDetails:stock.symbol withCompletion:^(NSDictionary *stockDictionary) {
            [Stock stockWithStockDetailDictionary:stockDictionary Context:[FISDataStore sharedDataStore].managedObjectContext];
            [[FISDataStore sharedDataStore] saveContext];
            
            NSLog(@"%@ now has bidprice = %@", stock.symbol, stock.bidPrice);
            
            // Increment results received
            stockResultsReceived = stockResultsReceived + 1;
            
            if (stockResultsReceived >= totalStocks)
            {
                NSLog(@"Finished retrieving data");
                // Send completion to the caller of this method
                completed(YES);
            }
            
            
            NSTimeInterval secondsSinceNotification = abs([stock.lastNotificationFiredTime timeIntervalSinceNow]);
            NSLog(@"Time Interval: %f", secondsSinceNotification);
            

            if (notification && (secondsSinceNotification > 60*60*24 || !stock.lastNotificationFiredTime)) {
                
                
                if ([stock.bidPrice floatValue] >= stock.userAlertPriceHigh && stock.userAlertPriceHigh > 0)
                {
                    NSLog(@"%@ has a bidprice %@ which is >= to the alert price high set at $%.2f",stock.symbol, stock.bidPrice, stock.userAlertPriceHigh);
                        
                    NSLog(@"last notification fired time: %@", stock.lastNotificationFiredTime);
                        
                    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                    localNotification.fireDate = [NSDate date];
                    localNotification.alertBody = [NSString stringWithFormat: @"%@ has reached %@", stock.symbol, stock.bidPrice];
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    localNotification.alertAction = @"Show me the item";
                    localNotification.timeZone = [NSTimeZone defaultTimeZone];
                    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
                        
                        
                    stock.lastNotificationFiredTime = [NSDate date];
                    [[FISDataStore sharedDataStore] saveContext];
                        
                    NSLog(@"%@", localNotification);
                }

                if ([stock.bidPrice floatValue] <= stock.userAlertPriceLow && stock.userAlertPriceLow > 0)
                {
                    NSLog(@"%@ has a bidprice %@ which is <= to the alert price low set at $%.2f",stock.symbol, stock.bidPrice, stock.userAlertPriceLow);
                    
                    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                    localNotification.fireDate = [NSDate date];
                    localNotification.alertBody = [NSString stringWithFormat: @"%@ has dropped to %@, which is lower than your alert of %f", stock.symbol, stock.bidPrice, stock.userAlertPriceLow];
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    localNotification.alertAction = @"Show me the item";
                    localNotification.timeZone = [NSTimeZone defaultTimeZone];
                    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
                    
                    
                    stock.lastNotificationFiredTime = [NSDate date];
                    [[FISDataStore sharedDataStore] saveContext];
                    
                    NSLog(@"%@", localNotification);
                }
            }
        }];
        
    }
    
         
}



@end

