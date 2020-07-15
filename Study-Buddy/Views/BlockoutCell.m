//
//  BlockoutCell.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "BlockoutCell.h"

@implementation BlockoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTimeBlock:(TimeBlock *)timeBlock {
    _timeBlock = timeBlock;
    self.daysLabel.text = [self.timeBlock getDaysString];
    self.timesLabel.text = [self.timeBlock getTimesString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
