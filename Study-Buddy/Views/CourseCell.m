//
//  CourseCell.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CourseCell.h"

@implementation CourseCell

- (void)setTimeBlock:(TimeBlock *)timeBlock {
    _timeBlock = timeBlock;
    __weak typeof(self) weakSelf = self;
    [self.timeBlock fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching timeblock: %@", error.localizedDescription);
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                __weak typeof(self) weakSelf2 = strongSelf;
                [strongSelf.timeBlock.course fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"Error fetching course for timeblock: %@", error.localizedDescription);
                    } else {
                        __strong typeof(self) strongSelf2 = weakSelf2;
                        if (strongSelf2) {
                            strongSelf2.courseNameLabel.text = strongSelf2.timeBlock.course.courseName;
                            strongSelf2.courseNumberLabel.text = strongSelf2.timeBlock.course.courseNumber;
                            strongSelf2.professorNameLabel.text = strongSelf2.timeBlock.course.professorName;
                        }
                    }
                }];
                strongSelf.daysLabel.text = [strongSelf.timeBlock getDaysString];
                strongSelf.timesLabel.text = [strongSelf.timeBlock getTimesString];
            }
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
