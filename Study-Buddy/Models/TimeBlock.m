//
//  TimeBlock.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "TimeBlock.h"
#import "DateTools.h"
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
NSString *const kMondayKey = @"monday";
NSString *const kTuesdayKey = @"tuesday";
NSString *const kWednesdayKey = @"wednesday";
NSString *const kThursdayKey = @"thursday";
NSString *const kFridayKey = @"friday";
NSString *const kSaturdayKey = @"saturday";
NSString *const kSundayKey = @"sunday";
NSString *const kCourseKey = @"course";

+ (nonnull NSString *)parseClassName {
    return @"TimeBlock";
}

#pragma mark - Creation

+ (void)addTimeBlockWithCourseName:(NSString *)courseName courseNumber:(NSString *)courseNumber professorName:(NSString *)professorName startTime:(NSDate *)startTime endTime:(NSDate *)endTime monday:(BOOL)monday tuesday:(BOOL)tuesday wednesday:(BOOL)wednesday thursday:(BOOL)thursday friday:(BOOL)friday saturday:(BOOL)saturday sunday:(BOOL)sunday withCompletion:(void(^)(TimeBlock *timeBlock, NSError *error))completion {
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
            if (error != nil) {
                NSLog(@"Error creating new block: %@", error.localizedDescription);
                completion(nil, error);
            } else {
                [[User currentUser] addObject:newBlock forKey:kScheduleKey];
                [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error != nil) {
                        completion(nil, error);
                    } else {
                        completion(newBlock, nil);
                    }
                }];
            }
        }];
    } else {
        NSLog(@"Adding to existing block");
        [match.course addObject:[User currentUser] forKey:kStudentsKey];
        [match saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error adding to existing block: %@", error.localizedDescription);
                completion(nil, error);
            } else {
                [[User currentUser] addObject:match forKey:kScheduleKey];
                [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error != nil) {
                        completion(nil, error);
                    } else {
                        completion(match, nil);
                    }
                }];
            }
        }];
    }
}

+ (void)addTimeBlockWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime monday:(BOOL)monday tuesday:(BOOL)tuesday wednesday:(BOOL)wednesday thursday:(BOOL)thursday friday:(BOOL)friday saturday:(BOOL)saturday sunday:(BOOL)sunday withCompletion:(void(^)(TimeBlock *timeBlock, NSError *error))completion {
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
        if (error != nil) {
            completion(nil, error);
        } else {
            [[User currentUser] addObject:newBlock forKey:kScheduleKey];
            [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                    completion(nil, error);
                } else {
                    completion(newBlock, nil);
                }
            }];
        }
    }];
}

#pragma mark - Query

- (TimeBlock *)getExistingMatchingTimeBlock {
    PFQuery *innerQuery = [Course query];
    [innerQuery whereKey:kCourseNameKey equalTo:self.course.courseName];
    [innerQuery whereKey:kCourseNumberKey equalTo:self.course.courseNumber];
    [innerQuery whereKey:kProfessorNameKey equalTo:self.course.professorName];
    
    PFQuery *query = [TimeBlock query];
    [query whereKey:kMondayKey equalTo:[NSNumber numberWithBool:self.monday]];
    [query whereKey:kTuesdayKey equalTo:[NSNumber numberWithBool:self.tuesday]];
    [query whereKey:kWednesdayKey equalTo:[NSNumber numberWithBool:self.wednesday]];
    [query whereKey:kThursdayKey equalTo:[NSNumber numberWithBool:self.thursday]];
    [query whereKey:kFridayKey equalTo:[NSNumber numberWithBool:self.friday]];
    [query whereKey:kSaturdayKey equalTo:[NSNumber numberWithBool:self.saturday]];
    [query whereKey:kSundayKey equalTo:[NSNumber numberWithBool:self.sunday]];
    [query whereKey:kCourseKey matchesQuery:innerQuery];
    
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

#pragma mark - Deletion

- (void)deleteExistingTimeBlockWithCompletion:(PFBooleanResultBlock)completion {
    [[User currentUser] removeObject:self forKey:kScheduleKey];
    [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            completion(NO, error);
        } else {
            if (self.isClass) {
                [self.course removeObject:[User currentUser] forKey:kStudentsKey];
                if (self.course.students.count == 0) {
                    [self.course deleteInBackground];
                    [self deleteInBackground];
                } else {
                    [self.course saveInBackground];
                }
            } else {
                [self deleteInBackground];
            }
            completion(YES, nil);
        }
    }];
}

#pragma mark - Strings

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

- (NSString *)getDurationString {
    DTTimePeriod *period = [DTTimePeriod timePeriodWithStartDate:self.startTime endDate:self.endTime];
    if (period.durationInHours != 1.0) {
        return [NSString stringWithFormat:@"Duration: %g hours", period.durationInHours];
    } else {
        return [NSString stringWithFormat:@"Duration: %g hour", period.durationInHours];
    }
}

@end
