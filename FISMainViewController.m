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
#import "UIColorSheet.h"
#import "PageScrollViewController.h"


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
        [self.stockTableView reloadData];
    }
    return self;
}


/////////////////////xib failing to load in TVC cells//////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
//    [self isFirstRun];

    self.dataStore = [FISDataStore sharedDataStore];
    
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate= self;
    [self.stockTableView reloadData];

    
    self.navigationController.navigationBar.barTintColor = [UIColorSheet clearColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bluenavbarlight_320x64.png"] forBarMetrics:UIBarMetricsDefault];
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
//    {
//        // app already launched
//        NSLog(@"This is not the first launch");
//    }
//    
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        // This is the first launch ever
//        NSLog(@"This is the first launch");

//    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
//                                objectForKey:@"aValue"]]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"aValue"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        NSLog(@"First app launch");
    
//        double delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
   
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"View1"];
//        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        
        
//        [self presentModalViewController:vc animated:YES];
        
        
//        [self performSegueWithIdentifier:@"tutorialSegue2" sender:self];
//        });
        
//        [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
//    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.stockTableView addSubview:refreshControl];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(reloadData:)
    name:@"EnteredForeground"
    object:nil];

    
    // Determine if default for areAlertsMuted is set
    BOOL shouldFireNotification;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"areAlertsMuted"])
    
    {
        if([defaults boolForKey:@"areAlertsMuted"])
            shouldFireNotification = NO;
        
        else
            shouldFireNotification = YES;
    }
    
    else
    
    {
        // Default hasn't been set yet so it definitely isn't muted
        shouldFireNotification = YES;
    }
    
    if (shouldFireNotification)
   
    {
        [self updateMuteButtonWithImageNamed:@"tinyalarmbutton_cancel.png"];
    }
    
    else
  
    {
        [self updateMuteButtonWithImageNamed:@"tinyalarmbutton.png"];
    }
}



- (void)updateMuteButtonWithImageNamed: (NSString *)imageName
{
    UIImage* cancelAlerts = [UIImage imageNamed:imageName];
    
    CGRect frameimg = CGRectMake(0, 0, cancelAlerts.size.width, cancelAlerts.size.height);
    
    UIButton *cancelAlertsButton = [[UIButton alloc] initWithFrame:frameimg];
    [cancelAlertsButton setBackgroundImage:cancelAlerts forState:UIControlStateNormal];
    [cancelAlertsButton addTarget:self action:@selector(muteAlerts)
                 forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButton =[[UIBarButtonItem alloc] initWithCustomView:cancelAlertsButton];
    self.navigationItem.leftBarButtonItem=cancelButton;
    
}

// Flip the status of the alerts
- (void)muteAlerts
{
    // Determine if default for areAlertsMuted is set
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"areAlertsMuted"])
    {
        // Flip the boolean value since it exists
        [defaults setBool:![defaults boolForKey:@"areAlertsMuted"] forKey:@"areAlertsMuted"];
    }
    else
    {
        // Default hasn't been set yet so switch to muted
        [defaults setBool:YES forKey:@"areAlertsMuted"];
    }
    
    // Must commit saving of the default value
    [defaults synchronize];
                  
    if ([defaults boolForKey:@"areAlertsMuted"])
    {
        [self updateMuteButtonWithImageNamed:@"tinyalarmbutton.png"];
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Message" message:@"Quote Alerts Muted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert show];

        NSLog(@"Un-Muting Alerts");
        
    }
    else
    {
        [self updateMuteButtonWithImageNamed:@"tinyalarmbutton_cancel.png"];
        
        UIAlertView *messageAlert2 = [[UIAlertView alloc]
                                     initWithTitle:@"Message" message:@"Quote Alerts Active" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert2 show];
        
        NSLog(@"Muting alerts");
    }
}


- (void)reloadData:(id)object {
    
//    [YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
    [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:NO WithCompletion:^(BOOL isSuccessful) {
        if (isSuccessful)
        {
            NSLog(@"Was successful");
            
        }
        
        else
        {
            NSLog(@"Not successful");
        }
    }];
    NSLog(@"reloaded Data from foreground");
}

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    
    //    [YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
    //    if (!self.stockTableView) {
    
//        if ([self.stocks count] != 0) {
    
            [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:NO WithCompletion:^(BOOL isSuccessful) {
    
    
                if (isSuccessful)
                {
    //            if (!self.stockTableView) {
    
                    NSLog(@"Was successful");
//                    [refreshControl endRefreshing];
                    [self.stockTableView reloadData];
    //            }
                }
    
                else
                {
                    NSLog(@"Not successful");
                }
            
        }];
//        }
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

//- (void)refresh:(UIRefreshControl *)refreshControl {
//    
////    [YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
////    if (!self.stockTableView) {
//    
//    if ([self.stocks count] != 0) {
//    
//        [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:NO WithCompletion:^(BOOL isSuccessful) {
//    
//        
//            if (isSuccessful)
//            {
////            if (!self.stockTableView) {
//            
//                NSLog(@"Was successful");
//                [refreshControl endRefreshing];
//                [self.stockTableView reloadData];
////            }
//            }
//
//            else
//            {
//                NSLog(@"Not successful");
//            }
//        
//    }];
//    }
//
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *searchSymbol = self.searchResults[indexPath.row][@"symbol"];
//    
//    [YahooAPIClient searchForStockDetails:searchSymbol withCompletion:^(NSDictionary *stockDictionary) {
//        [Stock stockWithStockDetailDictionary:stockDictionary Context:self.dataStore.managedObjectContext];
//        [self.dataStore saveContext];
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
//}

- (void)initialize
{
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [self.dataStore.fetchedStockResultsController performFetch:nil];
    
//    [YahooAPIClient fetchAllUserStocksUpdatesWithCompletion:^(BOOL isSuccessful) {
    [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:NO WithCompletion:^(BOOL isSuccessful) {
    
        if (isSuccessful)
        {
            NSLog(@"Was successful");
            [self.stockTableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.stockTableView reloadData];
            });
        }
        
        else
        {
            NSLog(@"Not successful");
        }
    }];
    
//    [self.stockTableView reloadData];
}

//- (BOOL) isFirstRun
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"isFirstRun"])
//    {
//        return NO;
//    }
//  
//    else
//    {
//        [defaults setObject:[NSDate date] forKey:@"isFirstRun"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [self performSegueWithIdentifier:@"tutorialSegue2" sender:self];
//
//    
//        return YES;
//    }


//    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
//                                objectForKey:@"isFirstRun"]])
    
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstRun"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSLog(@"First app launch");
//        //        [self performSegueWithIdentifier:@"tutorialSegue2" sender:self];
//        
////        [self dismissViewControllerAnimated:YES completion:^() {
//        [self performSegueWithIdentifier:@"tutorialSegue2" sender:self];
////        }];
//    }
//    
//    return YES;
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
        // On first launch, this block will execute
        
        [self performSegueWithIdentifier:@"tutorialSegue3" sender:self];
        NSLog(@"tutorial segue!");
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPerformedFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        // On subsequent launches, this block will execute
    }
    
}


- (void) setupNavBar
{

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
    NSLog(@"Number of fetched objects is %lu", (unsigned long)[[self.dataStore.fetchedStockResultsController fetchedObjects]count]);
    NSLog(@"Number of items in stock array is %lu", _stocks.count);
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
    cell.percentChangeLabel.text = stock.percentChange;
    
    cell.alertPriceHighLabel.text = [NSString stringWithFormat:@"%.2f", stock.userAlertPriceHigh];
    cell.alertPriceLowLabel.text = [NSString stringWithFormat:@"%.2f", stock.userAlertPriceLow];
    
    int stockChangeFloat = [stock.change intValue];
    
    if (stockChangeFloat >= 0.00) {
//        [cell.dayChangeLabel setBackgroundColor:[UIColor greenColor]];
//        [cell.percentChangeLabel setBackgroundColor:[UIColor greenColor]];
        [cell.dayChangeLabel setTextColor:[UIColor greenColor]];
        [cell.percentChangeLabel setTextColor:[UIColor greenColor]];

    }
    
    else{
//        [cell.dayChangeLabel setBackgroundColor:[UIColor redColor]];
//        [cell.percentChangeLabel setBackgroundColor:[UIColor redColor]];
        [cell.dayChangeLabel setTextColor:[UIColor redColor]];
        [cell.percentChangeLabel setTextColor:[UIColor redColor]];
    }
    
/////////////////////// if cell sends notification, highlight cell /////////////////////////
    
    int stockBidPriceFloat = [stock.bidPrice intValue];
    
    
    if ((stockBidPriceFloat >= stock.userAlertPriceHigh && stock.userAlertPriceHigh > 0) || (stockBidPriceFloat <= stock.userAlertPriceLow && stock.userAlertPriceLow > 0))
    {
        [cell setBackgroundColor:[UIColorSheet lightRedColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }

    
//    if (stockBidPriceFloat >= stock.userAlertPriceHigh && stock.userAlertPriceHigh > 0)
//    {
//        [cell setBackgroundColor: [UIColorSheet lightRedColor]];
//    }
//
//    if (stockBidPriceFloat <= stock.userAlertPriceLow && stock.userAlertPriceLow > 0)
//    {
//        [cell setBackgroundColor: [UIColorSheet lightRedColor]];
//    }
    
/////////////////////////////////////////////////////////////////////////////////////////////
    
    
    if ((stockBidPriceFloat <= stock.userAlertPriceHigh && stock.userAlertPriceHigh > 0) || (stockBidPriceFloat >= stock.userAlertPriceLow && stock.userAlertPriceLow > 0))
    {
        UIImage *alarmClockIcon = [UIImage imageNamed: @"tiny_alarmicon.png"];
        [cell.alarmClockImageView setImage:alarmClockIcon];
    }
    
    else
    {
        [cell.alarmClockImageView setImage:nil];
    }
    
    
    [cell.symbolLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.symbolLabel setTextColor:[UIColor whiteColor]];

    [cell.bidPriceLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.bidPriceLabel setTextColor:[UIColor whiteColor]];
    
    [cell.dayChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
//    [cell.dayChangeLabel setTextColor:[UIColor clearColor]];
    
    [cell.percentChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
//    [cell.percentChangeLabel setTextColor:[UIColor whiteColor]];
    
    [cell.alertPriceHighLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [cell.alertPriceHighLabel setTextColor:[UIColor yellowColor]];
    
    [cell.alertPriceLowLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [cell.alertPriceLowLabel setTextColor:[UIColor yellowColor]];
    
    return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //[self performSegueWithIdentifier:@"stockDetailSegue" sender:self];
//    
////    Stock *stock = [self.dataStore.fetchedStockResultsController objectAtIndexPath:indexPath];
//}


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
    
//    else if ([segue.identifier isEqualToString:@"tutorialSegue2"])
//    {
//        tutorialViewController *tutorialVC = segue.destinationViewController;
//        
////      [self performSegueWithIdentifier:@"tutorialSegue2" sender:self];
//    }
}


#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"controllerWillChangeContent");
    [self.stockTableView beginUpdates];
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        [self.stockTableView reloadData];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"controllerDidChangeContent");
    [self.stockTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
    NSLog(@"controller didChangeSection");
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
    
    NSLog(@"controller didChangeObject");
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
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataStore deleteStockAtIndexPay:indexPath];
        [self.dataStore.fetchedStockResultsController performFetch:nil];
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

