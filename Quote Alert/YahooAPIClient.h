//
//  YahooAPIClient.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/25/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface YahooAPIClient : NSObject

+ (void)getReposForQuery:(NSString *)query Completion:(void(^)(NSArray *repoDictionaries))completionBlock;

@end
