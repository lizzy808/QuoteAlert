//
//  FISSearchTableViewController.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/30/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock+Methods.h"
#import "FISStockSearch.h"

@interface FISSearchTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Stock *stock;
@property (strong, nonatomic) FISStockSearch *searchedStock;
@property (strong, nonatomic) NSDictionary *searchResult;



@end
