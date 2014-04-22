//
//  FISMainViewController.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/6/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISMainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FISDataStore.h"
#import "Stock+Methods.h"
#import "FISMainTableViewCell.h"
#import "FISStockDetailViewController.h"
#import "FISSearchTableViewController.h"
#import "YahooAPIClient.h"

@interface FISMainViewController ()

@property (nonatomic) NSArray *stocks;
@property (nonatomic) FISDataStore *dataStore;
@property (strong, nonatomic) Stock *stock;
@property (strong, nonatomic) NSDictionary *stockDict;


@end

@implementation FISMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/////////////////////xib failing to load in TVC cells//////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self setupNavBar];
    [self dummyFetch];
    
    [self.stockTableView registerNib:[UINib nibWithNibName:@"MainTVCell" bundle:nil] forCellReuseIdentifier:@"basicCell"];
    self.dataStore = [FISDataStore sharedDataStore];
    
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate= self;
    
}

- (void)initialize
{
    [self.stockTableView registerNib:[UINib nibWithNibName:@"MainTVCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate = self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    [self.dataStore saveSearchedStockSymbol:self.dataStore.searchSymbol];
//    UITableViewCell *cell = [self.stockTableView cellForRowAtIndexPath:self.indexPath];
//
//    if (![[self.stockTableView cellForRowAtIndexPath:self.indexPath] isEqual:nil])
//    {
//        [self.dataStore addStockDetailsWithSymbol:self.dataStore.searchSymbol];
//        NSLog(@"%@", self.dataStore.searchSymbol);
//   
//        [self.stockTableView reloadData];
//    }
//}

- (void) setupNavBar
{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"QAnavBar.png"] forBarMetrics:UIBarMetricsDefault];

    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataStore.fetchedStockResultsController.sections[0] numberOfObjects];
}


//- (FISMainTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FISMainTableViewCell *cell = (FISMainTableViewCell *)[self configureCellForMainTableViewWithIndexPath:indexPath];
//
//    return cell;
//}


////////////// Attempting to pass in dummy data /////////////////

- (FISMainTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.stockTableView) {
        
        [self dummyFetch];
        
        FISMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MainTVCell" owner:self options:nil] firstObject];
            
            NSDictionary *stocksDictionary = self.stocks [indexPath.row];
            
            cell.symbolLabel.text = stocksDictionary[@"Symbol"];
            cell.bidPriceLabel.text = stocksDictionary[@"Bid"];
            cell.dayChangeLabel.text = stocksDictionary[@"Change"];
            
//            cell.alertPriceHighLabel.text = stocksDictionary[@"exchDisp"];
//            cell.alertPriceLowLabel.text = stocksDictionary[@"name"];
            
            [self dummyFetch];
            [self.stockTableView reloadData];
        }
        
        
        return cell;
    }
    
    FISMainTableViewCell *cell = (FISMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"basicCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;

}

- (void)configureCell:(FISMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    Stock *stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:indexPath];
    
    cell.symbolLabel.text = self.stock.symbol;
    cell.bidPriceLabel.text = self.stock.bidPrice;
    cell.dayChangeLabel.text = self.stock.change;
}

///////////// not showing on TVC///////////

- (void)dummyFetch{
    [YahooAPIClient searchForStockDetails:@"YHOO" withCompletion:^(NSDictionary *stockDictionary) {
        NSLog(@"%@", stockDictionary);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stockDict = stockDictionary;
            [self.stockTableView reloadData];
        });
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"stockDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"stockDetailSegue"])
    {
//        NSIndexPath *index = [self.stockTableView indexPathForSelectedRow];
        
        FISStockDetailViewController *stockDetailTVC = segue.destinationViewController;
        FISMainTableViewCell *cell = (FISMainTableViewCell *)[self.stockTableView cellForRowAtIndexPath:[self.stockTableView indexPathForSelectedRow]];
        
        stockDetailTVC.stock = cell.stock;
        
        [self.stockTableView deselectRowAtIndexPath:[self.stockTableView indexPathForSelectedRow] animated:YES];
        
//        stockDetailTVC.stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:index];
    }
    else if ([segue.identifier isEqualToString:@"mainToSearchSegue"])
    {
        NSIndexPath *index = [self.stockTableView indexPathForSelectedRow];
        FISSearchTableViewController *searchTVC = (FISSearchTableViewController *)segue.destinationViewController;
        searchTVC.stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:index];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.stockTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.stockTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.stockTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.stockTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.stockTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
//                    atIndexPath:indexPath];
//            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.dataStore deleteStockAtIndexPay:indexPath];
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}






@end
