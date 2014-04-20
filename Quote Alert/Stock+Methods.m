//
//  Stock+Methods.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/26/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "Stock+Methods.h"

@implementation Stock (Methods)

- (NSString *)stockDetailDescription
{
    return [NSString stringWithFormat:@"Symbol: %@ Bid Price: %@ Change: %@ Volume: %@ Day High: %@ Day Low: %@ P/E Ratio: %@ Open Price: %@ Market Cap: %@ Year High: %@ Year Low: %@ Yield: %@ Average Volume: %@",self.symbol,self.bidPrice,self.change,self.volume,self.dayHigh,self.dayLow,self.peRatio,self.openPrice,self.mktCap,self.yearHigh,self.yearLow,self.yield,self.averageVolume];
}


+ (instancetype)stockWithStockDetailDictionary:(NSDictionary *)stockDetailDictionary Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSString *searchSymbol = stockDetailDictionary[@"Symbol"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"Symbol==%@",searchSymbol];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *repos = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([repos count]==0) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stock" inManagedObjectContext:context];
        Stock *repository = [[Stock alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        repository.symbol = stockDetailDictionary[@"Symbol"];
        repository.bidPrice = stockDetailDictionary[@"Bid"];
        repository.change = stockDetailDictionary[@"Change"];
        repository.volume = stockDetailDictionary[@"Volume"];
        repository.dayHigh = stockDetailDictionary[@"DaysHigh"];
        repository.dayLow = stockDetailDictionary[@"DaysLow"];
        repository.peRatio = stockDetailDictionary[@"PERatio"];
        repository.openPrice = stockDetailDictionary[@"Open"];
        repository.mktCap = stockDetailDictionary[@"MarketCapitalization"];
        repository.yearHigh = stockDetailDictionary[@"YearHigh"];
        repository.yearLow = stockDetailDictionary[@"YearLow"];
        repository.yield = stockDetailDictionary[@"DividendYield"];
        repository.averageVolume = stockDetailDictionary[@"AverageDailyVolume"];
        
        
        return repository;
    } else
    {
        Stock *selectedRepo = [repos lastObject];
        selectedRepo.bidPrice = stockDetailDictionary[@"Bid"];
        selectedRepo.change = stockDetailDictionary[@"Change"];
        selectedRepo.volume = stockDetailDictionary[@"Volume"];
        selectedRepo.dayHigh = stockDetailDictionary[@"DaysHigh"];
        selectedRepo.dayLow = stockDetailDictionary[@"DaysLow"];
        selectedRepo.peRatio = stockDetailDictionary[@"PERatio"];
        selectedRepo.openPrice = stockDetailDictionary[@"Open"];
        selectedRepo.mktCap = stockDetailDictionary[@"MarketCapitalization"];
        selectedRepo.yearHigh = stockDetailDictionary[@"YearHigh"];
        selectedRepo.yearLow = stockDetailDictionary[@"YearLow"];
        selectedRepo.yield = stockDetailDictionary[@"DividendYield"];
        selectedRepo.averageVolume = stockDetailDictionary[@"AverageDailyVolume"];
        
        return selectedRepo;
    }
}

@end
