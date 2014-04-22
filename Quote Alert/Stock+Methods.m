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
    return [NSString stringWithFormat:@"Symbol: %@ Bid Price: %@ Change: %@ Volume: %@ Day High: %@ Day Low: %@ P/E Ratio: %@ Open Price: %@ Market Cap: %@ Year High: %@ Year Low: %@ Yield: %@ Average Volume: %@ Company:%@ User Alert Price High:%@ User Alert Price Low:%@",self.symbol,self.bidPrice,self.change,self.volume,self.dayHigh,self.dayLow,self.peRatio,self.openPrice,self.mktCap,self.yearHigh,self.yearLow,self.yield,self.averageVolume,self.companyName,self.userAlertPriceHigh,self.userAlertPriceLow];
}


+ (instancetype)stockWithStockDetailDictionary:(NSDictionary *)stockDetailDictionary Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSString *searchSymbol = stockDetailDictionary[@"Symbol"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"symbol==%@",searchSymbol];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *repos = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([repos count]==0) {
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stock" inManagedObjectContext:context];
//        Stock *repository = [[Stock alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];

        Stock *repository = [NSEntityDescription insertNewObjectForEntityForName:@"Stock" inManagedObjectContext:context];
        
        repository.symbol = [self nullCheckWithObject:stockDetailDictionary[@"Symbol"]];
        
        repository.bidPrice = [self nullCheckWithObject:stockDetailDictionary [@"Bid"]];
        
        repository.change = [self nullCheckWithObject:stockDetailDictionary[@"Change"]];
        
        repository.volume = [self nullCheckWithObject:stockDetailDictionary[@"Volume"]];
        
        repository.dayHigh = [self nullCheckWithObject:stockDetailDictionary[@"DaysHigh"]];
        
        repository.dayLow = [self nullCheckWithObject:stockDetailDictionary[@"DaysLow"]];

        repository.peRatio = [self nullCheckWithObject:stockDetailDictionary[@"PERatio"]];

        repository.openPrice = [self nullCheckWithObject:stockDetailDictionary[@"Open"]];
        
        repository.mktCap = [self nullCheckWithObject:stockDetailDictionary[@"MarketCapitalization"]];
        
        repository.yearHigh = [self nullCheckWithObject:stockDetailDictionary[@"YearHigh"]];
        
        repository.yearLow = [self nullCheckWithObject:stockDetailDictionary[@"YearLow"]];
        
        repository.yield = [self nullCheckWithObject:stockDetailDictionary[@"DividendYield"]];
        
        repository.averageVolume = [self nullCheckWithObject:stockDetailDictionary[@"AverageDailyVolume"]];
        
        repository.companyName = [self nullCheckWithObject:stockDetailDictionary[@"Name"]];
        
        [context save:nil];
        
        return repository;
        
    } else
    {
        Stock *selectedRepo = [repos lastObject];
        selectedRepo.bidPrice = [self nullCheckWithObject:stockDetailDictionary[@"Bid"]];
        selectedRepo.change = [self nullCheckWithObject:stockDetailDictionary[@"Change"]];
        selectedRepo.volume = [self nullCheckWithObject:stockDetailDictionary[@"Volume"]];
        selectedRepo.dayHigh = [self nullCheckWithObject:stockDetailDictionary[@"DaysHigh"]];
        selectedRepo.dayLow = [self nullCheckWithObject:stockDetailDictionary[@"DaysLow"]];
        selectedRepo.peRatio = [self nullCheckWithObject:stockDetailDictionary[@"PERatio"]];
        selectedRepo.openPrice = [self nullCheckWithObject:stockDetailDictionary[@"Open"]];
        selectedRepo.mktCap = [self nullCheckWithObject:stockDetailDictionary[@"MarketCapitalization"]];
        selectedRepo.yearHigh = [self nullCheckWithObject:stockDetailDictionary[@"YearHigh"]];
        selectedRepo.yearLow = [self nullCheckWithObject:stockDetailDictionary[@"YearLow"]];
        selectedRepo.yield = [self nullCheckWithObject:stockDetailDictionary[@"DividendYield"]];
        selectedRepo.averageVolume = [self nullCheckWithObject:stockDetailDictionary[@"AverageDailyVolume"]];
        selectedRepo.companyName = [self nullCheckWithObject:stockDetailDictionary[@"Name"]];

        
        [context save:nil];
        
        return selectedRepo;
    }
}

+ (id)nullCheckWithObject:(id)object
{
    if (object != [NSNull null]) {
        return object;
    }
    return nil;
}

@end
