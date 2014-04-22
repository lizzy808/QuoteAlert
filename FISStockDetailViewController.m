//
//  FISStockDetailViewController.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/28/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISStockDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FISDataStore.h"
#import "Stock+Methods.h"
#import "FISMainTableViewCell.h"
#import "FISSearchTableViewController.h"
#import "YahooAPIClient.h"

@interface FISStockDetailViewController ()

@property (strong,nonatomic) FISDataStore *dataStore;
@property (nonatomic) NSArray *stocks;
@property (strong, nonatomic) NSDictionary *stockDict;

- (IBAction)backBarButtonTapped:(id)sender;
- (IBAction)saveQuotesButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayChangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *openPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *mktCapLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yieldLabel;

@property (weak, nonatomic) IBOutlet UITextField *qaHighTextField;
@property (weak, nonatomic) IBOutlet UITextField *qaLowTextField;


@end

@implementation FISStockDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewStockDetail];
//    [self saveQuoteAlerts];

    self.dataStore = [FISDataStore sharedDataStore];
    // Do any additional setup after loading the view.
    self.dataStore.fetchedStockResultsController.delegate= self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)saveQuoteAlerts
//{
//    self.qaHighTextField.text = self.stock.userAlertPriceHigh;
//    self.qaLowTextField.text = self.stock.userAlertPriceLow;
//    
//    [self.dataStore saveContext];
//}

- (void)viewStockDetail
{
    [self.symbolLabel setText:self.stock.companyName];
    
    self.priceLabel.text = self.stock.bidPrice;
    self.dayChangeLabel.text = self.stock.change;
    self.openPriceLabel.text = self.stock.openPrice;
    self.dayHighLabel.text = self.stock.dayHigh;
    self.dayLowLabel.text = self.stock.dayLow;
    self.volumeLabel.text = self.stock.volume;
    self.peRatioLabel.text = self.stock.peRatio;
    self.mktCapLabel.text = self.stock.mktCap;
    self.yearHighLabel.text = self.stock.yearHigh;
    self.yearLowLabel.text = self.stock.yearLow;
    self.avgVolumeLabel.text = self.stock.averageVolume;
    self.yieldLabel.text = self.stock.yield;

    [self.priceLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.priceLabel setTextColor:[UIColor yellowColor]];
    [self.dayChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.dayChangeLabel setTextColor:[UIColor yellowColor]];
    [self.symbolLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
    [self.symbolLabel setTextColor:[UIColor yellowColor]];
    [self.openPriceLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.openPriceLabel setTextColor:[UIColor yellowColor]];
    [self.dayHighLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.dayHighLabel setTextColor:[UIColor yellowColor]];
    [self.dayLowLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.dayLowLabel setTextColor:[UIColor yellowColor]];
    [self.volumeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.volumeLabel setTextColor:[UIColor yellowColor]];
    [self.peRatioLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.peRatioLabel setTextColor:[UIColor yellowColor]];
    [self.mktCapLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.mktCapLabel setTextColor:[UIColor yellowColor]];
    [self.yearLowLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.yearLowLabel setTextColor:[UIColor yellowColor]];
    [self.yearHighLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.yearHighLabel setTextColor:[UIColor yellowColor]];
    [self.avgVolumeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.avgVolumeLabel setTextColor:[UIColor yellowColor]];
    [self.yieldLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.yieldLabel setTextColor:[UIColor yellowColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBarButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveQuotesButtonTapped:(id)sender
{
     self.stock.userAlertPriceHigh = self.qaHighTextField.text;
     self.stock.userAlertPriceLow = self.qaLowTextField.text;
    
    [self.dataStore saveContext];
}

@end
