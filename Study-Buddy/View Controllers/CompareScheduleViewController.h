//
//  CompareScheduleViewController.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompareScheduleViewController : UIViewController

@property (strong, nonatomic) User *user;
extern NSString *const kPageViewControllerIdentifier;

@end

NS_ASSUME_NONNULL_END
