//
//  FISSearchTableViewCell.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/1/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISStockSearch.h"

@class FISStockSearch;

@interface FISSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeNameLabel;

@property (strong, nonatomic) FISSearchTableViewCell *cell;
@property (strong, nonatomic) FISStockSearch *searchedStock;


+ (instancetype)cellConfiguredWithSearchedStock: (FISStockSearch *)searchedStock;
- (instancetype)configuredWithSearchedStock: (FISStockSearch *)searchedStock;


@end
