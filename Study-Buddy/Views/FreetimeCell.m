//
//  FreetimeCell.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "FreetimeCell.h"

@implementation FreetimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTimeBlock:(TimeBlock *)timeBlock {
    _timeBlock = timeBlock;
    self.timeLabel.text = [timeBlock getTimesString];
    self.durationLabel.text = [timeBlock getDurationString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
