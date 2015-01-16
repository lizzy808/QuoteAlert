//
//  FISStockSearch.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/9/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISStockSearch.h"

@implementation FISStockSearch

@dynamic symbol;
@dynamic name;
@dynamic stockExchange;

- (NSString *)stockSearchDescription
{
    return [NSString stringWithFormat:@"Symbol: %@ Name: %@ Stock Exchange: %@",self.symbol,self.name,self.stockExchange];
}

+ (instancetype)stockWithStockSearchDictionary:(NSDictionary *)stockSearchDictionary Context:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSString *searchSymbol = stockSearchDictionary[@"symbol"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"symbol==%@",searchSymbol];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *repos = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([repos count]==0) {

        FISStockSearch *repository = [FISStockSearch new];
        repository.symbol = stockSearchDictionary[@"symbol"];
        repository.name = stockSearchDictionary[@"name"];
        repository.stockExchange = stockSearchDictionary[@"exchDisp"];
        
        return repository;
    } else
    {
        FISStockSearch *selectedRepo = [repos lastObject];
        
        selectedRepo.symbol = stockSearchDictionary[@"symbol"];
        selectedRepo.name = stockSearchDictionary[@"name"];
        selectedRepo.stockExchange = stockSearchDictionary[@"exchDisp"];
        return selectedRepo;
    }
}

@end
