//
//  TimeBlock.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "Course.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeBlock : PFObject<PFSubclassing>

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (assign, nonatomic) BOOL isClass;
@property (assign, nonatomic) BOOL monday;
@property (assign, nonatomic) BOOL tuesday;
@property (assign, nonatomic) BOOL wednesday;
@property (assign, nonatomic) BOOL thursday;
@property (assign, nonatomic) BOOL friday;
@property (assign, nonatomic) BOOL saturday;
@property (assign, nonatomic) BOOL sunday;
@property (strong, nonatomic) Course *course;

@end

NS_ASSUME_NONNULL_END
