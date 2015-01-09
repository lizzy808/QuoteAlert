//
//  PageViewController.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 1/8/15.
//  Copyright (c) 2015 Elizabeth Choy. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController


+ (void)initialize {
    if (self == PageViewController.class) {
        UIPageControl *pageControl = UIPageControl.appearance;
        pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
}

- (NSArray *)pageIdentifiers {
    return @[@"TutorialViewController1", @"TutorialViewController2", @"TutorialViewController3", @"TutorialViewController4"];
}


@end
