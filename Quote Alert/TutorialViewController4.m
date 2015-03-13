//
//  TutorialViewController4.m
//  Quote Alert
//
//  Created by Scott Martin on 1/9/15.
//  Copyright (c) 2015 Elizabeth Choy. All rights reserved.
//

#import "TutorialViewController4.h"
#import "PageViewController.h"

@interface TutorialViewController4 ()

- (IBAction)doneTapped:(id)sender;


@end

@implementation TutorialViewController4



- (IBAction)doneTapped:(id)sender {
    
    // Dismiss the tutorial view controller when user taps done
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
