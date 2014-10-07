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
- (IBAction)cancelButtonTapped:(id)sender;

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

            NSDictionary *searchResultDetails = self.searchResults [indexPath.row];
            
            cell.exchangeNameLabel.text = searchResultDetails[@"exchDisp"];
            cell.companyNameLabel.text = searchResultDetails[@"name"];
            cell.stockNameLabel.text = searchResultDetails[@"symbol"];
        }
        return cell;
    }
    FISSearchTableViewCell *cell = (FISSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (void)configureCell:(FISSearchTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
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


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
        [YahooAPIClient searchForStockWithName:searchBar.text withCompletion:^(NSArray *stockDictionaries) {
            NSLog(@"stock dictionaries = %@", stockDictionaries);
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchSymbol = self.searchResults[indexPath.row][@"symbol"];
    
    [YahooAPIClient searchForStockDetails:searchSymbol withCompletion:^(NSDictionary *stockDictionary) {
        [Stock stockWithStockDetailDictionary:stockDictionary Context:self.dataStore.managedObjectContext];
        [self.dataStore saveContext];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
}


- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
