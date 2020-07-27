//
//  StudentCell.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/17/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface StudentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
