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




@end
