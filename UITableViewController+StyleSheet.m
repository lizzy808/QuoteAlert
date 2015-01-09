//
//  UITableViewController+StyleSheet.m
//  Quote Alert
//
//  Created by Elizabeth Choy on 4/3/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import "UITableViewController+StyleSheet.h"

@implementation UITableViewController (StyleSheet)


+ (void)setBackgroundImage:(UIImage *)bgImage ForView:(UIView *)view
{
    // Set up checkboard background
    UIGraphicsBeginImageContext(view.frame.size);
    [bgImage drawAsPatternInRect:view.bounds];
    UIImage *bgNewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:bgNewImage];
}


@end
