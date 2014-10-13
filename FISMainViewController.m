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

@property (nonatomic) NSMutableArray *stocks;
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

    self.dataStore = [FISDataStore sharedDataStore];
    
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate= self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.stockTableView addSubview:refreshControl];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.dataStore.fetchedStockResultsController performFetch:nil];
    
    [self.stockTableView reloadData];
    
    NSLog(@"Refreshing data!");
    
    [refreshControl endRefreshing];
}


- (void)initialize
{
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.dataStore.fetchedStockResultsController performFetch:nil];
    
    [self.stockTableView reloadData];
}


- (void) setupNavBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"QAnavBar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataStore.fetchedStockResultsController fetchedObjects]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureStockCellAtIndexPath:indexPath];
}


- (FISMainTableViewCell *)configureStockCellAtIndexPath:(NSIndexPath *)indexPath
{
    FISMainTableViewCell *cell = [self.stockTableView dequeueReusableCellWithIdentifier:@"basicCell"];
    
    Stock *stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:indexPath];
    
    cell.stock = stock;
    cell.symbolLabel.text = stock.symbol;
    cell.bidPriceLabel.text = stock.bidPrice;
    cell.dayChangeLabel.text = stock.change;
    cell.alertPriceHighLabel.text = stock.userAlertPriceHigh;
    cell.alertPriceLowLabel.text = stock.userAlertPriceLow;
    
    [cell.symbolLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
    [cell.symbolLabel setTextColor:[UIColor whiteColor]];

    [cell.bidPriceLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.bidPriceLabel setTextColor:[UIColor whiteColor]];
    
    [cell.dayChangeLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.dayChangeLabel setTextColor:[UIColor whiteColor]];
    
    [cell.alertPriceHighLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.alertPriceHighLabel setTextColor:[UIColor whiteColor]];
    
    [cell.alertPriceLowLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.alertPriceLowLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"stockDetailSegue" sender:self];
    
//    Stock *stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:indexPath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"stockDetailSegue"])
    {
        FISStockDetailViewController *stockDetailTVC = segue.destinationViewController;
        FISMainTableViewCell *cell = (FISMainTableViewCell *)[self.stockTableView cellForRowAtIndexPath:[self.stockTableView indexPathForSelectedRow]];
        
        stockDetailTVC.stock = cell.stock;
        
        [self.stockTableView deselectRowAtIndexPath:[self.stockTableView indexPathForSelectedRow] animated:YES];
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
            
        case NSFetchedResultsChangeUpdate:
            [self configureStockCellAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataStore deleteStockAtIndexPay:indexPath];
        [self.stocks removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}




@end
