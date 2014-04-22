//
//  Stock.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/22/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stock : NSManagedObject

@property (nonatomic, retain) NSString * averageVolume;
@property (nonatomic, retain) NSString * bidPrice;
@property (nonatomic, retain) NSString * change;
@property (nonatomic, retain) NSString * dayHigh;
@property (nonatomic, retain) NSString * dayLow;
@property (nonatomic, retain) NSString * mktCap;
@property (nonatomic, retain) NSString * openPrice;
@property (nonatomic, retain) NSString * peRatio;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSString * volume;
@property (nonatomic, retain) NSString * yearHigh;
@property (nonatomic, retain) NSString * yearLow;
@property (nonatomic, retain) NSString * yield;
@property (nonatomic, retain) NSString * userAlertPriceHigh;
@property (nonatomic, retain) NSString * userAlertPriceLow;
@property (nonatomic, retain) NSString * companyName;

@end
