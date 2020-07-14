//
//  CourseCell.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *professorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (strong, nonatomic) TimeBlock *timeBlock;

@end

NS_ASSUME_NONNULL_END
