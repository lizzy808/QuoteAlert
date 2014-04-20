//
//  FISSearchTableViewController.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/30/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISSearchTableViewController.h"
#import "FISDataStore.h"
#import "FISMainViewController.h"
#import "YahooAPIClient.h"
#import "FISSearchTableViewCell.h"

@interface FISSearchTableViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>


@property (nonatomic) NSArray *stocks;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSDictionary *detailResults;
@property (nonatomic) FISDataStore *dataStore;
@property (strong, nonatomic) NSMutableArray *selectedCells;

@property (weak, nonatomic) IBOutlet UITableView *stockSearchTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *stockSearchBar;
- (IBAction)doneButtonTapped:(id)sender;

@end

@implementation FISSearchTableViewController

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

    self.stockSearchTableView.dataSource = self;
    self.stockSearchTableView.delegate = self;
    [self setupNavBar];
    
    self.dataStore = [FISDataStore sharedDataStore];
    self.dataStore.fetchedStockResultsController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupNavBar
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 65)];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    }
    else{
        return [self.stocks count]; 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        NSDictionary *stock = self.searchResults [indexPath.row];
        cell.textLabel.text = stock[@"name"];
        return cell;
    }
    
    FISSearchTableViewCell *cell = (FISSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
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
    Stock *stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:indexPath];
//    cell.exchangeNameLabel.text = stock.stockExchange;
//    cell.companyNameLabel.text = stock.name;
    cell.stockNameLabel.text = self.searchedStock.symbol;
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

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
        [YahooAPIClient searchForStockWithName:searchBar.text withCompletion:^(NSArray *stockDictionaries) {
            NSLog(@"%@", stockDictionaries);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchResults = stockDictionaries;
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }];
}

- (void)initialize
{
    [self.stockSearchTableView registerNib:[UINib nibWithNibName:@"searchView" bundle:nil] forCellReuseIdentifier:@"basicCell"];
    self.dataStore = [FISDataStore sharedDataStore];
    self.stockSearchTableView.delegate = self;
    self.stockSearchTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate = self;
}

//- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
//{
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//}

//Handle selection on searchBar
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellString = [NSString stringWithString:cell.textLabel.text];
    
    if ([self.selectedCells containsObject:@(indexPath.row)]) {
        [YahooAPIClient searchForStockDetails:cellString withCompletion:^(NSDictionary *stockDictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailResults = stockDictionary;
                
                NSLog(@"%@", stockDictionary);

                
                FISMainViewController *mainVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"FISMainViewController"];
                [self.navigationController pushViewController:mainVC animated:YES];
            });
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.selectedCells removeObject:@(indexPath.row)];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self performSegueWithIdentifier: @"UpdateData" sender: self];
    }
}

@end
