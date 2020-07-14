//
//  TimeBlock.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "TimeBlock.h"

@implementation TimeBlock

@dynamic startTime;
@dynamic endTime;
@dynamic isClass;
@dynamic monday;
@dynamic tuesday;
@dynamic wednesday;
@dynamic thursday;
@dynamic friday;
@dynamic saturday;
@dynamic sunday;
@dynamic course;

+ (nonnull NSString *)parseClassName {
    return @"TimeBlock";
}

@end
