//
//  TimeblockCreateViewController.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TimeblockCreateViewControllerDelegate

- (void)didCreateTimeblock:(TimeBlock *)timeblock;

@end

@interface TimeblockCreateViewController : UIViewController

@property (weak, nonatomic) id<TimeblockCreateViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
