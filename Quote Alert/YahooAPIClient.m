//
//  YahooAPIClient.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/25/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "YahooAPIClient.h"

@implementation YahooAPIClient

+ (void)getReposForQuery:(NSString *)query Completion:(void (^)(NSArray *))completionBlock
{
    static NSString *yahooSearchURLString = @"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback";
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager GET:yahooSearchURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDictionary = responseObject;
        NSArray *repositoriesDictionaries = responseDictionary[@"items"];
        completionBlock(repositoriesDictionaries);
    } failure:nil];
    

}

@end
