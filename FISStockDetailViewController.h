//
//  FISStockDetailViewController.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/28/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface FISStockDetailViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic)Stock *stock;
@property (strong, nonatomic) NSManagedObject *managedObject;

@end
