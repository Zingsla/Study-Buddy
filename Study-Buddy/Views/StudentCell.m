//
//  StudentCell.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/17/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "StudentCell.h"

@implementation StudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(User *)user {
    _user = user;
    [self.user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching user: %@", error.localizedDescription);
        } else {
            self.nameLabel.text = [self.user getNameString];
            self.majorLabel.text = self.user.major;
            self.yearLabel.text = [self.user getYearString];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
