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
#import "YahooAPIClient.h"
#import <Parse/Parse.h>


@interface FISMainViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];

    self.dataStore = [FISDataStore sharedDataStore];
    self.stockTableView.delegate = self;
    self.stockTableView.dataSource = self;
    self.dataStore.fetchedStockResultsController.delegate= self;
    [self.stockTableView reloadData];
    
    [self configureStockTableView];
    
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    
//    PFObject *stock = [PFObject objectWithClassName:@"StockAlerts"];
//    stock[@"symbol"] = @"TSLA";
//    stock[@"userAlertPriceHigh"] = @1;
//    stock[@"userAlertPriceLow"] = @2;
//    [stock saveInBackground];
    
//    NSLog(@"stock: %@", stock [@"symbol"]);
    
    
    
    [self supportedInterfaceOrientations];
    [self preferredInterfaceOrientationForPresentation];
    
    self.navigationController.navigationBar.barTintColor = [UIColorSheet clearColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bluenavbarlight_320x64.png"] forBarMetrics:UIBarMetricsDefault];
    
    
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
        [self updateMuteButtonWithImageNamed:@"alarmclockbutton_off1.png"];
    }
    
    else
  
    {
        [self updateMuteButtonWithImageNamed:@"alarmclockbutton_on1.png"];
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
        [self updateMuteButtonWithImageNamed:@"alarmclockbutton_on1.png"];
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Message" message:@"Quote Alerts Muted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert show];

        NSLog(@"Un-Muting Alerts");
        
        [FISDataStore changeParseNotifcationEnabledTo:NO];
        
    }
    else
    {
        [self updateMuteButtonWithImageNamed:@"alarmclockbutton_off1.png"];
        
        UIAlertView *messageAlert2 = [[UIAlertView alloc]
                                     initWithTitle:@"Message" message:@"Quote Alerts Active" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display Alert Message
        [messageAlert2 show];
        
        NSLog(@"Muting alerts");
        
        [FISDataStore changeParseNotifcationEnabledTo:YES];

    }
}


- (void)reloadData:(id)object {
    
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
    [YahooAPIClient fetchAllUserStocksUpdatesShouldFireNotification:NO WithCompletion:^(BOOL isSuccessful)
    {
    
        if (isSuccessful)
        {
            NSLog(@"Was successful");
            [self.stockTableView reloadData];
        }
    
        else
        {
            NSLog(@"Not successful");
        }
            
    }];
    
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}


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
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
        // On first launch, this block will execute
        
        [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
        NSLog(@"tutorial segue!");
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPerformedFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [YahooAPIClient searchForStockDetails:@"aapl" withCompletion:^(NSDictionary *stockDictionary) {
            self.stock.userAlertPriceHigh = 200.00;
            self.stock.userAlertPriceLow = 75.00;
    
            [Stock stockWithStockDetailDictionary:stockDictionary Context:self.dataStore.managedObjectContext];
            [self.dataStore saveContext];
        }];
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

-(void)configureStockTableView
{
    self.stockTableView.frame = self.view.bounds;
    self.stockTableView.frame = self.view.frame;    
    self.stockTableView.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
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
//    NSLog(@"Number of items in stock array is %lu", _stocks.count);
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
    cell.companyNameLabel.text = stock.companyName;
    cell.bidPriceLabel.text = stock.bidPrice;
    
    float stockChangeFloat = [stock.change floatValue];
    cell.dayChangeLabel.text = [NSString stringWithFormat:@"%.2f", stockChangeFloat];
    
    cell.percentChangeLabel.text = stock.percentChange;
    
    cell.alertPriceHighLabel.text = [NSString stringWithFormat:@"%.2f", stock.userAlertPriceHigh];
    cell.alertPriceLowLabel.text = [NSString stringWithFormat:@"%.2f", stock.userAlertPriceLow];
    
    
    if (stockChangeFloat >= 0.00)
    {
        [cell.dayChangeLabel setTextColor:[UIColor greenColor]];
        [cell.percentChangeLabel setTextColor:[UIColor greenColor]];

    }
    
    else
    {
        [cell.dayChangeLabel setTextColor:[UIColor redColor]];
        [cell.percentChangeLabel setTextColor:[UIColor redColor]];
    }
    
// if cell sends notification, highlight cell
    
    float stockBidPriceFloat = [stock.bidPrice floatValue];
    
    
    if ((stockBidPriceFloat >= stock.userAlertPriceHigh && stock.userAlertPriceHigh > 0) || (stockBidPriceFloat <= stock.userAlertPriceLow && stock.userAlertPriceLow > 0))
    {
        [cell setBackgroundColor:[UIColorSheet lightRedColor]];
    }
    
    else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    if ((stockBidPriceFloat <= stock.userAlertPriceHigh && stock.userAlertPriceHigh > 0) || (stockBidPriceFloat >= stock.userAlertPriceLow && stock.userAlertPriceLow > 0))
    {
        UIImage *alarmClockIcon = [UIImage imageNamed: @"tiny_alarmicon.png"];
        [cell.alarmClockImageView setImage:alarmClockIcon];
    }
    
    else
    {
        [cell.alarmClockImageView setImage:nil];
    }
    
    [cell.symbolLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
    [cell.symbolLabel setTextColor:[UIColor whiteColor]];
    
    [cell.companyNameLabel setFont:[UIFont fontWithName:@"Arial" size:10]];
    [cell.companyNameLabel setTextColor:[UIColor whiteColor]];

    [cell.bidPriceLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.bidPriceLabel setTextColor:[UIColor whiteColor]];
    
    [cell.dayChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    
    [cell.percentChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    
    [cell.alertPriceHighLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [cell.alertPriceHighLabel setTextColor:[UIColor yellowColor]];
    
    [cell.alertPriceLowLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [cell.alertPriceLowLabel setTextColor:[UIColor yellowColor]];
    
    return cell;
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
    NSLog(@"controllerWillChangeContent");
    [self.stockTableView beginUpdates];
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
        
        
        
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert)
//    {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}




@end

