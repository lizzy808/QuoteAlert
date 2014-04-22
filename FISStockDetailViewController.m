//
//  FISStockDetailViewController.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/28/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "FISStockDetailViewController.h"
#import "FISDataStore.h"
#import <AFNetworking/AFNetworking.h>
#import "Stock+Methods.h"
#import "YahooAPIClient.h"

@interface FISStockDetailViewController ()

@property (strong,nonatomic) FISDataStore *dataStore;
@property (strong,nonatomic) UIView *stockDetailView;
- (IBAction)backBarButtonTapped:(id)sender;

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

//    [YahooAPIClient searchForStockDetails:self.stock withCompletion:^(id newStock)
//    {
//        self.stock = [Stock stockWithStockDetailDictionary:newStock inContext:self.dataStore.managedObjectContext];
//        [self.tableView reloadData];
//    }];
//}
//
//+ (void)searchForStockDetails:(NSString *)symbol withCompletion:(void (^)(NSDictionary *))completion
//
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataStore = [FISDataStore sharedDataStore];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewStockDetail
{
    
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

@end
