//
//  ComparePageContentViewController.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComparePageContentViewController : UIViewController

@property (assign, nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSString *dayText;
@property (strong, nonatomic) NSArray *freeTimes;

@end

NS_ASSUME_NONNULL_END
