//
//  FISMainViewController.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/6/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface FISMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObject *managedObject;
@property (weak, nonatomic) IBOutlet UITableView *stockTableView;
@property (strong, nonatomic) NSString *searchSymbol;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
