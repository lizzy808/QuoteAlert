//
//  YahooAPIClient.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/25/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "YahooAPIClient.h"
#import <AFNetworking/AFNetworking.h>

@interface YahooAPIClient()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation YahooAPIClient



- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    return _sessionManager;
}


+ (void)searchForStockWithName:(NSString *)name withCompletion:(void (^)(NSArray *stockDictionaries))completion{
    NSString *yahooURLString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback", name];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:yahooURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", data);
        
//        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
//        
//        [sessionManager GET:yahooURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"%@",responseObject);
//            completion (
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            <#code#>
//        }]
        
        NSString *newString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *cleanJSON = [newString substringFromIndex:39];
        cleanJSON = [cleanJSON substringToIndex:[cleanJSON length]-1];
        
        NSData *parsedData = [cleanJSON dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *stockDictionary = [NSJSONSerialization JSONObjectWithData:parsedData options:NSJSONReadingAllowFragments error:nil];
        NSArray *results = stockDictionary [@"ResultSet"][@"Result"];
        
        completion(results);
        
    }] resume];
    
}

+ (void)searchForStockDetails:(NSString *)symbol withCompletion:(void (^)(NSDictionary *))completion
{
    NSString *yahooDetailURLString = @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22";
    yahooDetailURLString = [yahooDetailURLString stringByAppendingString:symbol];
    yahooDetailURLString = [yahooDetailURLString stringByAppendingString:@"%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="];
       
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:yahooDetailURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", data);
        
        NSString *newString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *stockDetailDictionary = [NSJSONSerialization JSONObjectWithData:[newString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        completion(stockDetailDictionary);
        
    }] resume];
    
}

//+ (void)deleteStock:(Stock *)deleteStock Completion:(void (^)(id))completionBlock
//{
//    
//    NSString *symbol = deleteStock.symbol;
//    
//    NSString *triviaURLString =[NSString stringWithFormat:@"http://locationtrivia.herokuapp.com/locations/%@/trivia/%@.json?key=%@", locationID, triviaID, key];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager DELETE:triviaURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Failure");
//    }];
//}

@end
