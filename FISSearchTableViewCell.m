//
//  FISSearchTableViewCell.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/1/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISSearchTableViewCell.h"
#import "Stock+Methods.h"

@implementation FISSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellConfiguredWithSearchedStock:(FISStockSearch *)searchedStock
{
    FISSearchTableViewCell *cell = [FISSearchTableViewCell new];
    [cell configuredWithSearchedStock:searchedStock];
    return cell;
}

- (instancetype)configuredWithSearchedStock:(FISStockSearch *)searchedStock
{
    self.searchedStock = _searchedStock;
    
    self.stockNameLabel.text = self.searchedStock.symbol;
    self.companyNameLabel.text = self.searchedStock.name;
    self.exchangeNameLabel.text = self.searchedStock.stockExchange;
    
    self.stockNameLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.stockNameLabel.textColor = [UIColor whiteColor];
    self.companyNameLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.companyNameLabel.textColor = [UIColor whiteColor];
    self.exchangeNameLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.exchangeNameLabel.textColor = [UIColor whiteColor];
    
    return self;
    
}

@end
