//
//  FISMainTableViewCell.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/6/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stock;

@interface FISMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertPriceHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertPriceLowLabel;

@property (strong,nonatomic) Stock *stock;
@property (strong,nonatomic) FISMainTableViewCell *cell;

+ (instancetype) cellConfiguredWithStock: (Stock *)stock;
- (instancetype) configureWithStock: (Stock *)stock;

@end
