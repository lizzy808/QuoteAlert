//
//  Stock+Methods.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/26/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "Stock+Methods.h"

@implementation Stock (Methods)

- (NSString *)description
{
    return [NSString stringWithFormat:@"Symbol: %@ Name: %@ Bid Price: %@ Change: %@ Volume: %@ Day High: %@ Day Low: %@ P/E Ratio: %@ Open Price: %@ Market Cap: %@ Year High: %@ Year Low: %@ Yield: %@ Average Volume: %@ ",self.symbol,self.name,self.bidPrice,self.change,self.volume,self.dayHigh,self.dayLow,self.peRatio,self.openPrice,self.mktCap,self.yearHigh,self.yearLow,self.yield,self.averageVolume];
}


+ (instancetype)repoWithRepoDictionary:(NSDictionary *)repositoryDictionary Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSString *searchSymbol = [repositoryDictionary[@"Symbol"] stringValue];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"stockSymbol==%@",searchSymbol];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *repos = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([repos count]==0) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stock" inManagedObjectContext:context];
        Stock *repository = [[Stock alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        repository.symbol = repositoryDictionary[@"Symbol"];
        repository.name = repositoryDictionary[@"Name"];
        repository.bidPrice = repositoryDictionary[@"Bid"];
        repository.change = repositoryDictionary[@"Change"];
        repository.volume = repositoryDictionary[@"Volume"];
        repository.dayHigh = repositoryDictionary[@"DaysHigh"];
        repository.dayLow = repositoryDictionary[@"DaysLow"];
        repository.peRatio = repositoryDictionary[@"PERatio"];
        repository.openPrice = repositoryDictionary[@"Open"];
        repository.mktCap = repositoryDictionary[@"MarketCapitalization"];
        repository.yearHigh = repositoryDictionary[@"YearHigh"];
        repository.yearLow = repositoryDictionary[@"YearLow"];
        repository.yield = repositoryDictionary[@"DividendYield"];
        repository.averageVolume = repositoryDictionary[@"AverageDailyVolume"];
        
        
        return repository;
    } else
    {
        Stock *selectedRepo = [repos lastObject];
        selectedRepo.name = repositoryDictionary[@"Name"];
        selectedRepo.bidPrice = repositoryDictionary[@"Bid"];
        selectedRepo.change = repositoryDictionary[@"Change"];
        selectedRepo.volume = repositoryDictionary[@"Volume"];
        selectedRepo.dayHigh = repositoryDictionary[@"DaysHigh"];
        selectedRepo.dayLow = repositoryDictionary[@"DaysLow"];
        selectedRepo.peRatio = repositoryDictionary[@"PERatio"];
        selectedRepo.openPrice = repositoryDictionary[@"Open"];
        selectedRepo.mktCap = repositoryDictionary[@"MarketCapitalization"];
        selectedRepo.yearHigh = repositoryDictionary[@"YearHigh"];
        selectedRepo.yearLow = repositoryDictionary[@"YearLow"];
        selectedRepo.yield = repositoryDictionary[@"DividendYield"];
        selectedRepo.averageVolume = repositoryDictionary[@"AverageDailyVolume"];

        return selectedRepo;
    }
}

@end
