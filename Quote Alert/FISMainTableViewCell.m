//
//  FISMainTableViewCell.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/6/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISMainTableViewCell.h"
#import "Stock+Methods.h"

@implementation FISMainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellConfiguredWithStock:(Stock *)stock
{
    FISMainTableViewCell *cell = [FISMainTableViewCell new];
    [cell configureWithStock:stock];
    
    return cell;
}

- (instancetype)configureWithStock:(Stock *)stock
{
    self.stock = stock;
    self.symbolLabel.text = self.stock.symbol;
    self.bidPriceLabel.text = self.stock.bidPrice;
    self.dayChangeLabel.text = self.stock.change;
    self.alertPriceHighLabel.text = [NSString stringWithFormat:@"%.2f", self.stock.userAlertPriceHigh];
    self.alertPriceLowLabel.text = [NSString stringWithFormat:@"%.2f", self.stock.userAlertPriceLow ];
    
    
    
    self.symbolLabel.font = [UIFont fontWithName:@"Ubuntu" size:16];
    self.symbolLabel.textColor = [UIColor greenColor];
    self.bidPriceLabel.font = [UIFont fontWithName:@"Ubuntu" size:14];
    self.bidPriceLabel.textColor = [UIColor whiteColor];
    self.dayChangeLabel.font = [UIFont fontWithName:@"Ubuntu" size:14];
    self.dayChangeLabel.textColor = [UIColor whiteColor];
    
    
    return self;
}







@end
