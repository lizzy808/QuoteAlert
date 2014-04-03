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
    return [NSString stringWithFormat:@"Symbol: %@ Name: %@ Bid Price: %@ Change: %@ Volume: %@ Day High: %@ Day Low: %@ P/E Ratio: %@ Open Price: %@ Market Cap: %@ Year High: %@ Year Low: %@ Yield: %@ Average Volume: %@ Stock Exchange: %@",self.symbol,self.name,self.bidPrice,self.change,self.volume,self.dayHigh,self.dayLow,self.peRatio,self.openPrice,self.mktCap,self.yearHigh,self.yearLow,self.yield,self.averageVolume,self.stockExchange];
}

///////////////// Need a new managed object for Stock Search?//////////////

+ (instancetype)stockWithStockSearchDictionary:(NSDictionary *)stockSearchDictionary Context:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSString *searchSymbol = stockSearchDictionary[@"symbol"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"symbol==%@",searchSymbol];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *repos = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([repos count]==0) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stock" inManagedObjectContext:context];
        Stock *repository = [[Stock alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        repository.symbol = stockSearchDictionary[@"symbol"];
        repository.name = stockSearchDictionary[@"name"];
        repository.stockExchange = stockSearchDictionary[@"exchDisp"];
        
        
        return repository;
    } else
    {
        Stock *selectedRepo = [repos lastObject];
        
        selectedRepo.symbol = stockSearchDictionary[@"symbol"];
        selectedRepo.name = stockSearchDictionary[@"name"];
        selectedRepo.stockExchange = stockSearchDictionary[@"exchDisp"];
        return selectedRepo;
    }
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
        repository.name = stockDetailDictionary[@"Name"];
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
        repository.stockExchange = stockDetailDictionary[@"StockExchange"];
        
        
        return repository;
    } else
    {
        Stock *selectedRepo = [repos lastObject];
        selectedRepo.name = stockDetailDictionary[@"Name"];
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
        selectedRepo.stockExchange = stockDetailDictionary[@"StockExchange"];
        
        return selectedRepo;
    }
}

@end
