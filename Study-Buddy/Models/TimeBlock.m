//
//  TimeBlock.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "TimeBlock.h"
#import "User.h"

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

+ (void)addTimeBlockWithCourseName:(NSString *)courseName courseNumber:(NSString *)courseNumber professorName:(NSString *)professorName startTime:(NSDate *)startTime endTime:(NSDate *)endTime monday:(BOOL)monday tuesday:(BOOL)tuesday wednesday:(BOOL)wednesday thursday:(BOOL)thursday friday:(BOOL)friday saturday:(BOOL)saturday sunday:(BOOL)sunday withCompletion:(PFBooleanResultBlock)completion{
    Course *newCourse = [Course new];
    newCourse.courseName = courseName;
    newCourse.courseNumber = courseNumber;
    newCourse.professorName = professorName;
    newCourse.students = [[NSMutableArray alloc] init];
    [newCourse.students addObject:[User currentUser]];
    
    TimeBlock *newBlock = [TimeBlock new];
    newBlock.course = newCourse;
    newBlock.startTime = startTime;
    newBlock.endTime = endTime;
    newBlock.monday = monday;
    newBlock.tuesday = tuesday;
    newBlock.wednesday = wednesday;
    newBlock.thursday = thursday;
    newBlock.friday = friday;
    newBlock.saturday = saturday;
    newBlock.sunday = sunday;
    newBlock.isClass = YES;
    
    [newBlock saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            [[User currentUser] addObject:newBlock forKey:@"schedule"];
            [[User currentUser] saveInBackgroundWithBlock:completion];
        }
    }];
}

- (NSString *)getDaysString {
    NSString *string = @"";
    if (self.monday) {
        string = [string stringByAppendingString:@"M"];
    }
    if (self.tuesday) {
        string = [string stringByAppendingString:@"T"];
    }
    if (self.wednesday) {
        string = [string stringByAppendingString:@"W"];
    }
    if (self.thursday) {
        string = [string stringByAppendingString:@"R"];
    }
    if (self.friday) {
        string = [string stringByAppendingString:@"F"];
    }
    if (self.saturday) {
        string = [string stringByAppendingString:@"S"];
    }
    if (self.sunday) {
        string = [string stringByAppendingString:@"U"];
    }
    
    return string;
}

- (NSString *)getTimesString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:self.startTime], [dateFormatter stringFromDate:self.endTime]];
}

@end
