//
//  FreetimeCell.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface FreetimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) TimeBlock *timeBlock;

@end

NS_ASSUME_NONNULL_END
