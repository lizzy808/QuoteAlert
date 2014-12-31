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
    return [NSString stringWithFormat:@"Symbol: %@ Percent Change: %@ Bid Price: %@ Change: %@ Volume: %@ Day High: %@ Day Low: %@ P/E Ratio: %@ Open Price: %@ Market Cap: %@ Year High: %@ Year Low: %@ Yield: %@ Average Volume: %@ Company:%@ User Alert Price High:%@ User Alert Price Low:%@",self.symbol,self.percentChange, self.bidPrice,self.change,self.volume,self.dayHigh,self.dayLow,self.peRatio,self.openPrice,self.mktCap,self.yearHigh,self.yearLow,self.yield,self.averageVolume,self.companyName,[NSString stringWithFormat:@"%.2f", self.userAlertPriceHigh],[NSString stringWithFormat:@"%.2f", self.userAlertPriceLow]];
}


+ (instancetype)stockWithStockDetailDictionary:(NSDictionary *)stockDetailDictionary Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stock"];
    NSString *searchSymbol = stockDetailDictionary[@"Symbol"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"symbol==%@",searchSymbol];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *repos = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([repos count]==0) {

        Stock *repository = [NSEntityDescription insertNewObjectForEntityForName:@"Stock" inManagedObjectContext:context];
        
        repository.symbol = [self nullCheckWithObject:stockDetailDictionary[@"Symbol"]];
        
        repository.percentChange = [self nullCheckWithObject:stockDetailDictionary[@"ChangeinPercent"]];
        
//        repository.bidPrice = [self nullCheckWithObject:stockDetailDictionary [@"Bid"]];

        repository.bidPrice = [self nullCheckWithObject:stockDetailDictionary [@"LastTradePriceOnly"]];
        
        repository.change = [self nullCheckWithObject:stockDetailDictionary[@"Change"]];
        
        repository.volume = [self nullCheckWithObject:stockDetailDictionary[@"Volume"]];
        
        repository.dayHigh = [self nullCheckWithObject:stockDetailDictionary[@"DaysHigh"]];
        
        
        repository.dayHighDecimal = [self decimalFromObject:stockDetailDictionary[@"DaysHigh"]];
        repository.dayHighFormatted = [self formattedCurrencyFromDecimal:repository.dayHighDecimal];
        
        
        
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
        selectedRepo.bidPrice = [self nullCheckWithObject:stockDetailDictionary[@"LastTradePriceOnly"]];
        selectedRepo.percentChange = [self nullCheckWithObject:stockDetailDictionary[@"ChangeinPercent"]];
        
//        selectedRepo.bidPrice = [self nullCheckWithObject:stockDetailDictionary[@"Bid"]];
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



+ (NSDecimalNumber *)decimalFromObject: (NSObject *)object
{
    
    if (object != [NSNull null])
    {
        NSString *stringFromObject = (NSString *)object;
        NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithString:stringFromObject];
        NSLog(@"Converted '%@' to decimalNum %@", stringFromObject, decimalNum);
        return decimalNum;
    }
    else
    {
        return nil;
    }

}

+ (NSString *)formattedCurrencyFromDecimal: (NSDecimalNumber *)number
{
    
    if (number)
    {
        // Format the number to dollars and cents. This defaults to the phone locale for currency to use
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *formattedString = [formatter stringFromNumber:number];
        NSLog(@"Converted decimalNum %@ to formattedString %@", number, formattedString);
        return formattedString;
    }
    else
    {
        return @"None";
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
