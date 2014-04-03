//
//  FISSearchTableViewController.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/30/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISSearchTableViewController.h"
#import "FISDataStore.h"
#import "FISMainTableViewController.h"
#import "YahooAPIClient.h"
#import "Stock.h"
#import "Stock+Methods.h"
#import "FISSearchTableViewCell.h"

@interface FISSearchTableViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>


@property (nonatomic) NSArray *stocks;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) FISDataStore *dataStore;

@end

@implementation FISSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataStore = [FISDataStore sharedDataStore];
    self.dataStore.fetchedResultsController.delegate = self;
    [self.dataStore fetchStocksFromAPI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    }
    else{
        return [self.stocks count]; 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISSearchTableViewCell *cell = (FISSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"basicCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
    
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[RecipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Display recipe in the table cell
//    Stock *stock = [recipes objectAtIndex:indexPath.row];
//    cell.stock.text = recipe.name;
//    cell.thumbnailImageView.image = [UIImage imageNamed:recipe.image];
//    cell.prepTimeLabel.text = recipe.prepTime;
//    
//    return cell;
//}
}
- (void)configureCell:(FISSearchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Stock *stock = [self.dataStore.fetchedResultsController objectAtIndexPath:indexPath];
    cell.exchangeNameLabel.text = stock.stockExchange;
    cell.companyNameLabel.text = stock.name;
    cell.stockNameLabel.text = stock.symbol;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"symbol contains[c] %@", searchText];
    _searchResults = [self.stocks filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
