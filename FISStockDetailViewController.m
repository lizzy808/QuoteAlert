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
#import "Stock+Methods.h"
#import "UIColorSheet.h"
#import "FISMainViewController.h"
#import <Parse/Parse.h>

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
@property (weak, nonatomic) IBOutlet UILabel *percentChangeLabel;

@property (weak, nonatomic) IBOutlet UITextField *qaHighTextField;
@property (weak, nonatomic) IBOutlet UITextField *qaLowTextField;

@property (weak, nonatomic) IBOutlet UIWebView *graphWebView;


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

    self.dataStore = [FISDataStore sharedDataStore];
    self.dataStore.fetchedStockResultsController.delegate= self;
    
    
    
    [self.graphWebView loadRequest:[NSURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://chart.finance.yahoo.com/z?s=GOOG&t=1d&q=l&l=on&z=m"]]];

    
    [self.qaHighTextField setText:[NSString stringWithFormat:@"%.2f", self.stock.userAlertPriceHigh]];
    [self.qaLowTextField setText:[NSString stringWithFormat:@"%.2f", self.stock.userAlertPriceLow]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewStockDetail
{
    [self.symbolLabel setText:self.stock.companyName];
    
    self.priceLabel.text = self.stock.bidPrice;
//    self.priceLabel.text
    
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
    self.percentChangeLabel.text = self.stock.percentChange;

    [self.priceLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.priceLabel setTextColor:[UIColor yellowColor]];
    [self.dayChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.percentChangeLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    
    float stockChangeFloat = [self.stock.change floatValue];
    self.dayChangeLabel.text = [NSString stringWithFormat:@"%.2f", stockChangeFloat];
    
    if (stockChangeFloat >= 0.00) {
        [self.dayChangeLabel setTextColor:[UIColor greenColor]];
        [self.percentChangeLabel setTextColor:[UIColor greenColor]];
    }
    else{
        [self.dayChangeLabel setTextColor:[UIColor redColor]];
        [self.percentChangeLabel setTextColor:[UIColor redColor]];
    }
    
    [self.symbolLabel setFont:[UIFont fontWithName:@"Arial" size:24]];
    [self.symbolLabel setTextColor:[UIColor yellowColor]];
    [self.openPriceLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.openPriceLabel setTextColor:[UIColor yellowColor]];
    [self.dayHighLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.dayHighLabel setTextColor:[UIColor yellowColor]];
    [self.dayLowLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.dayLowLabel setTextColor:[UIColor yellowColor]];
    [self.volumeLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.volumeLabel setTextColor:[UIColor yellowColor]];
    [self.peRatioLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.peRatioLabel setTextColor:[UIColor yellowColor]];
    [self.mktCapLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.mktCapLabel setTextColor:[UIColor yellowColor]];
    [self.yearLowLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.yearLowLabel setTextColor:[UIColor yellowColor]];
    [self.yearHighLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.yearHighLabel setTextColor:[UIColor yellowColor]];
    [self.avgVolumeLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.avgVolumeLabel setTextColor:[UIColor yellowColor]];
    [self.yieldLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.yieldLabel setTextColor:[UIColor yellowColor]];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 130.0)];
    [path addLineToPoint:CGPointMake(320.0, 130.0)];
    
    
    [path moveToPoint:CGPointMake(0.0, 360.0)];
    [path addLineToPoint:CGPointMake(320.0, 360.00)];

    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.view.layer addSublayer:shapeLayer];
}


- (IBAction)backBarButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveQuotesButtonTapped:(id)sender
{
    
     self.stock.userAlertPriceHigh = [self.qaHighTextField.text floatValue];
     self.stock.userAlertPriceLow = [self.qaLowTextField.text floatValue];
/*
 Enables notification if user changes alert prices
*/
    
    self.stock.lastNotificationFiredTime = nil;
    

    PFQuery *query = [PFQuery queryWithClassName:@"StockAlerts"];
    
    NSString *currentInstallationId;
    PFInstallation *installation = [PFInstallation currentInstallation];
    currentInstallationId = installation[@"installationId"];
    
    [query whereKey:@"symbol" equalTo:self.stock.symbol];
    [query whereKey:@"installationId" equalTo:currentInstallationId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *stockAlerts, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)stockAlerts.count);
            // Do something with the found objects
            for (PFObject *stockAlert in stockAlerts)
            {
                NSLog(@"%@", stockAlert.objectId);
                
                NSNumber *userAlertPriceHighNumber = [NSNumber numberWithFloat:self.stock.userAlertPriceHigh];
                NSNumber *userAlertPriceLowNumber = [NSNumber numberWithFloat:self.stock.userAlertPriceLow];
                
                stockAlert[@"userAlertPriceHigh"] = userAlertPriceHighNumber;
                stockAlert[@"userAlertPriceLow"] = userAlertPriceLowNumber;
                
                NSLog(@"%@", stockAlert[@"userAlertPriceHigh"]);
                
                [stockAlert saveInBackground];
                [stockAlert fetch];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

/*
     Update PFObject alert price properties
*/

    
//    PFObject *stockObject = [PFObject objectWithClassName:@"StockAlerts"];
//    
////    NSNumber *userAlertPriceHighNumber = [NSNumber numberWithFloat:self.stock.userAlertPriceHigh];
////    NSNumber *userAlertPriceLowNumber = [NSNumber numberWithFloat:self.stock.userAlertPriceLow];
////    
////    if ([stockObject[@"symbol"] isEqualToString:self.stock.symbol])
////    {
////        PFQuery *query = [PFQuery queryWithClassName:@"StockAlerts"];
////        
////        [query getFirstObjectInBackgroundWithTarget:self selector:(SEL)
////        
////        {
////            stockObject[@"userAlertPriceHigh"] = userAlertPriceHighNumber;
////            stockObject[@"userAlertPriceLow"] = userAlertPriceLowNumber;
////        
////            [stockObject saveInBackground];
////        }];
////    }
//    
//    
//    
//    
//    stockObject[@"symbol"] = self.stock.symbol;
//    
//    NSNumber *userAlertPriceHighNumber = [NSNumber numberWithFloat:self.stock.userAlertPriceHigh];
//    NSNumber *userAlertPriceLowNumber = [NSNumber numberWithFloat:self.stock.userAlertPriceLow];
//    
//    stockObject[@"userAlertPriceHigh"] = userAlertPriceHighNumber;
//    stockObject[@"userAlertPriceLow"] = userAlertPriceLowNumber;
//
//    [stockObject saveInBackground];
//    [stockObject fetch];
    
/*
     Update PFObject with user stock alert numbers
*/
    
    
    [self.dataStore saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];

    NSLog(@"High price limit:%@, Low Price Limit: %@", self.qaHighTextField, self.qaLowTextField);
}



#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField *)textField up: (BOOL) up
{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.qaHighTextField resignFirstResponder];
    [self.qaLowTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.qaLowTextField resignFirstResponder];
    [self.qaHighTextField resignFirstResponder];
    return YES;
}




@end
