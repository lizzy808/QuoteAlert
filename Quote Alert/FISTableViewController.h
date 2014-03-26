//
//  FISTableViewController.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/25/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
