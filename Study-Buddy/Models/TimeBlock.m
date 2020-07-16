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
    
    TimeBlock *match = [newBlock getExistingMatchingTimeBlock];
    if (match == nil) {
        NSLog(@"Creating new block");
        [newBlock saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                [[User currentUser] addObject:newBlock forKey:@"schedule"];
                [[User currentUser] saveInBackgroundWithBlock:completion];
            }
        }];
    } else {
        NSLog(@"Adding to existing block");
        [match.course addObject:[User currentUser] forKey:@"students"];
        [match saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                [[User currentUser] addObject:match forKey:@"schedule"];
                [[User currentUser] saveInBackgroundWithBlock:completion];
            }
        }];
    }
}

+ (void)addTimeBlockWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime monday:(BOOL)monday tuesday:(BOOL)tuesday wednesday:(BOOL)wednesday thursday:(BOOL)thursday friday:(BOOL)friday saturday:(BOOL)saturday sunday:(BOOL)sunday withCompletion:(PFBooleanResultBlock)completion {
    TimeBlock *newBlock = [TimeBlock new];
    newBlock.startTime = startTime;
    newBlock.endTime = endTime;
    newBlock.monday = monday;
    newBlock.tuesday = tuesday;
    newBlock.wednesday = wednesday;
    newBlock.thursday = thursday;
    newBlock.friday = friday;
    newBlock.saturday = saturday;
    newBlock.sunday = sunday;
    newBlock.isClass = NO;
    
    [newBlock saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            [[User currentUser] addObject:newBlock forKey:@"schedule"];
            [[User currentUser] saveInBackgroundWithBlock:completion];
        }
    }];
}

- (TimeBlock *)getExistingMatchingTimeBlock {
    PFQuery *innerQuery = [Course query];
    [innerQuery whereKey:@"courseName" equalTo:self.course.courseName];
    [innerQuery whereKey:@"courseNumber" equalTo:self.course.courseNumber];
    [innerQuery whereKey:@"professorName" equalTo:self.course.professorName];
    
    PFQuery *query = [TimeBlock query];
    [query whereKey:@"monday" equalTo:[NSNumber numberWithBool:self.monday]];
    [query whereKey:@"tuesday" equalTo:[NSNumber numberWithBool:self.tuesday]];
    [query whereKey:@"wednesday" equalTo:[NSNumber numberWithBool:self.wednesday]];
    [query whereKey:@"thursday" equalTo:[NSNumber numberWithBool:self.thursday]];
    [query whereKey:@"friday" equalTo:[NSNumber numberWithBool:self.friday]];
    [query whereKey:@"saturday" equalTo:[NSNumber numberWithBool:self.saturday]];
    [query whereKey:@"sunday" equalTo:[NSNumber numberWithBool:self.sunday]];
    [query whereKey:@"course" matchesQuery:innerQuery];
    
    TimeBlock *match = nil;
    NSArray *blocks = [query findObjects];
    for (TimeBlock *block in blocks) {
        if ([[block getTimesString] isEqualToString:[self getTimesString]]) {
            NSLog(@"Found matching timeblock!");
            match = block;
        }
    }
    
    return match;
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

- (NSString *)getStartTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [dateFormatter stringFromDate:self.startTime];
}

- (NSString *)getEndTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [dateFormatter stringFromDate:self.endTime];
}

- (NSString *)getTimesString {
    return [NSString stringWithFormat:@"%@ - %@", [self getStartTimeString], [self getEndTimeString]];
}

@end
