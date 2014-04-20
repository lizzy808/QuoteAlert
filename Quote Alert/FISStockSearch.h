//
//  FISStockSearch.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/9/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISStockSearch : NSObject

@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * stockExchange;

+ (instancetype)stockWithStockSearchDictionary:(NSDictionary *)stockSearchDictionary Context:(NSManagedObjectContext *)context;


@end
