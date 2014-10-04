//
//  YahooAPIClient.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/25/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Stock+Methods.h"
#import "FISStockSearch.h"

@interface YahooAPIClient : NSObject

+ (void)searchForStockWithName: (NSString *)name withCompletion:(void(^)(NSArray *stockDictionaries))completion;

+ (void)searchForStockDetails:(NSString *)symbol withCompletion:(void (^)(NSDictionary *))completion;

+ (void)fetchUserStocks:(NSString *)symbol withCompletion:(void (^)(NSDictionary *))completion;
//+ (void)getStockSearchResults:(FISStockSearch *)searchResults withCompletion:(void (^)(NSArray *stockSearchResults))completionBlock;

@end
