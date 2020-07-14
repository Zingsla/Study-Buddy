//
//  Course.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "Course.h"

@implementation Course

@dynamic courseName;
@dynamic courseNumber;
@dynamic professorName;
@dynamic students;

+ (nonnull NSString *)parseClassName {
    return @"Course";
}

@end
