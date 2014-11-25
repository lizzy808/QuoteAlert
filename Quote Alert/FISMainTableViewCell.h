//
//  FISMainTableViewCell.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/6/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@class Stock;

@interface FISMainTableViewCell : SWTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertPriceHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertPriceLowLabel;
@property (weak, nonatomic) IBOutlet UIButton *dayChangeColorButton;


@property (strong,nonatomic) Stock *stock;
@property (strong,nonatomic) FISMainTableViewCell *cell;
@property (strong, nonatomic) SWTableViewCell *sWcell;

+ (instancetype) cellConfiguredWithStock: (Stock *)stock;
- (instancetype) configureWithStock: (Stock *)stock;

@end
