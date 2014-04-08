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

@interface FISMainViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSArray *stocks;
@property (nonatomic) FISDataStore *dataStore;

@property (weak, nonatomic) IBOutlet UITableView *stockTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addStockButton;
- (IBAction)addStockButtonTapped:(id)sender;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [FISDataStore sharedDataStore];
    
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedResultsController.delegate = self;
    [self.dataStore fetchStocksFromAPI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataStore.fetchedResultsController.sections[section] numberOfObjects];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stockCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Stock *stock = [self.dataStore.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = stock.symbol;
}

- (void)prepareForSegue:(UIStoryboardSegue *)detailSegue sender:(id)sender
{
    if ([detailSegue.identifier isEqualToString:@"stockDetailSegue"])
    {
        NSIndexPath *index = [self.stockTableView indexPathForSelectedRow];
        
        FISStockDetailViewController *stockDetailTVC = (FISStockDetailViewController *)detailSegue.destinationViewController;
        
        stockDetailTVC.stock = [self.dataStore.fetchedResultsController objectAtIndexPath:index];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)addStockSegue sender:(id)sender
//{
//    if ([addStockSegue.identifier isEqualToString:@"addStockSegue"])
//    {
//        NSIndexPath *index = [self.stockTableView indexPathForSelectedRow];
//        FISSearchTableViewController *searchTVC = (FISSearchTableViewController *)addStockSegue.destinationViewController;
//        searchTVC.stock = [self.dataStore.fetchedResultsController objectAtIndexPath:index];
//    }
//}

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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
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

- (IBAction)addStockButtonTapped:(id)sender {
    [self.dataStore fetchStocksFromAPI];
}


@end
