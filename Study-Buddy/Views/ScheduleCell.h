//
//  ScheduleCell.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCell : UITableViewCell

@property (strong, nonatomic) TimeBlock *timeBlock;

@end

NS_ASSUME_NONNULL_END
