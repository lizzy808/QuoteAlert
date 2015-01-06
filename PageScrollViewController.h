//
//  PageScrollViewController.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 1/5/15.
//  Copyright (c) 2015 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageScrollViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;


@end
