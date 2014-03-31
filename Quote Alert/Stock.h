//
//  Stock.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/30/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stock : NSManagedObject

@property (nonatomic, retain) NSNumber * averageVolume;
@property (nonatomic, retain) NSNumber * bidPrice;
@property (nonatomic, retain) NSNumber * change;
@property (nonatomic, retain) NSNumber * dayHigh;
@property (nonatomic, retain) NSNumber * dayLow;
@property (nonatomic, retain) NSNumber * mktCap;
@property (nonatomic, retain) NSNumber * openPrice;
@property (nonatomic, retain) NSNumber * peRatio;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSNumber * yearHigh;
@property (nonatomic, retain) NSNumber * yearLow;
@property (nonatomic, retain) NSNumber * yield;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * stockExchange;

@end
