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
    self.courseNameLabel.text = self.timeBlock.course.courseName;
    self.courseNumberLabel.text = self.timeBlock.course.courseNumber;
    self.professorNameLabel.text = self.timeBlock.course.professorName;
    self.daysLabel.text = [self.timeBlock getDaysString];
    self.timesLabel.text = [self.timeBlock getTimesString];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
