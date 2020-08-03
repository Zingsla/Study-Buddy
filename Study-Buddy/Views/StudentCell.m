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
}

- (void)setUser:(User *)user {
    _user = user;
    __weak typeof(self) weakSelf = self;
    [self.user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching user: %@", error.localizedDescription);
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.nameLabel.text = [strongSelf.user getNameString];
                strongSelf.majorLabel.text = strongSelf.user.major;
                strongSelf.yearLabel.text = [strongSelf.user getYearString];
                strongSelf.profileImageView.layer.cornerRadius = strongSelf.profileImageView.frame.size.width / 2;
                [strongSelf.profileImageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                [strongSelf.profileImageView.layer setBorderWidth:2];
                if (user.profileImage != nil) {
                     strongSelf.profileImageView.file = user.profileImage;
                     [strongSelf.profileImageView loadInBackground];
                } else {
                    strongSelf.profileImageView.image = [UIImage systemImageNamed:@"person"];
                }
            }
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
