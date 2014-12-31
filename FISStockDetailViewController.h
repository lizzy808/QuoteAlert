//
//  FISStockDetailViewController.h
//  Quote Alert
//
//  Created by Elizabeth Choy on 3/28/14.
//  Copyright (c) 2014 Elizabeth Choy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface FISStockDetailViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic)Stock *stock;
@property (strong, nonatomic) NSManagedObject *managedObject;

- (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
                        image:(UIImage *)image;

@end
