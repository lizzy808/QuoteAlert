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
#import "FISSearchTableViewCell.h"


@interface FISSearchTableViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>


@property (nonatomic) NSArray *stocks;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSDictionary *detailResults;
@property (nonatomic) FISDataStore *dataStore;
@property (strong, nonatomic) NSMutableArray *selectedCells;
@property (strong, nonatomic) FISSearchTableViewCell *cell;

@property (strong, nonatomic) NSString *searchSymbol;
///////////send symbol to datastore from SearchVC, in MainVC viewdidLoad/Appear if symbol is non-nil, do details api call

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
    [self initialize];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar2"] forBarMetrics:UIBarMetricsDefault];
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



- (FISSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController.searchResultsTableView setTintColor:[UIColor blackColor]];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        FISSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell == nil) {
           cell = [[[NSBundle mainBundle]loadNibNamed:@"searchView" owner:self options:nil] firstObject];
            
       self.searchResult = self.searchResults [indexPath.row];
            
            cell.exchangeNameLabel.text = self.searchResult[@"exchDisp"];
            cell.companyNameLabel.text = self.searchResult[@"name"];
            cell.stockNameLabel.text = self.searchResult[@"symbol"];
            
//            NSString *searchedSymbol = self.searchResult[@"symbol"];
//            [self.dataStore saveSearchedStockSymbol:searchedSymbol];
        }
        return cell;
    }
    
    FISSearchTableViewCell *cell = (FISSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)configureCell:(FISSearchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    Stock *stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:indexPath];
    
    cell.exchangeNameLabel.text = self.searchedStock.stockExchange;
    cell.companyNameLabel.text = self.searchedStock.name;
    cell.stockNameLabel.text = self.searchedStock.symbol;
}


- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"symbol contains[c] %@", searchText];
    self.searchResults = [self.stocks filteredArrayUsingPredicate:resultPredicate];
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
                [self.stockSearchTableView reloadData];
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }];
    
}


- (void)initialize
{
    [self.stockSearchTableView registerNib:[UINib nibWithNibName:@"searchView" bundle:nil] forCellReuseIdentifier:@"searchViewCell"];
    self.dataStore = [FISDataStore sharedDataStore];
    self.stockSearchTableView.delegate = self;
    self.stockSearchTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate = self;
    NSLog(@"%@",self.searchedStock);
}

//- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
//{
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//}

//Handle selection on searchBar

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

//    [NSDictionary *searchResult = self.searchResults [indexPath.row]];
    NSString *searchSymbol = self.searchResult[@"symbol"];
    
    [YahooAPIClient searchForStockDetails:searchSymbol withCompletion:^(NSDictionary *stockDictionary) {
        [Stock stockWithStockDetailDictionary:stockDictionary Context:self.dataStore.managedObjectContext];
        [self.dataStore saveContext];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }];

//    [self.navigationController popToRootViewControllerAnimated:YES];
}
//    [self.dataStore saveSearchedStockSymbol:searchSymbol];

    
//cell.exchangeNameLabel.text = searchResult[@"exchDisp"];
//cell.companyNameLabel.text = searchResult[@"name"];
//cell.stockNameLabel.text = searchResult[@"symbol"];
//
//NSString *searchedSymbol = searchResult[@"symbol"];
//[self.dataStore saveSearchedStockSymbol:searchedSymbol];

//    NSString *cellString = [NSString stringWithString:cell.textLabel.text];
    
////////////// attempt to pass stock symbol into Detail API call////
//    if ([self.selectedCells containsObject:@(indexPath.row)]) {
//        [YahooAPIClient searchForStockDetails:cellString withCompletion:^(NSDictionary *stockDictionary) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.detailResults = stockDictionary;
//                
//                NSLog(@"%@", stockDictionary);
//
//                
//                FISMainViewController *mainVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"FISMainViewController"];
//                [self.navigationController pushViewController:mainVC animated:YES];
//            });
//        }];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self.selectedCells removeObject:@(indexPath.row)];
//    }
    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self performSegueWithIdentifier: @"UpdateData" sender: self];
    
//    [self dismissViewControllerAnimated:YES completion:nil];

//    }


@end
