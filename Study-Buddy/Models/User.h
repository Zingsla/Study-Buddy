//
//  User.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) PFFileObject *profileImage;
@property (strong, nonatomic) NSArray *schedule;
@property (strong, nonatomic) NSArray *buddies;

@end

NS_ASSUME_NONNULL_END
