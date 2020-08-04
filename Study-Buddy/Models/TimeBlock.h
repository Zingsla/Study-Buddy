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
extern NSString *const kMondayKey;
extern NSString *const kTuesdayKey;
extern NSString *const kWednesdayKey;
extern NSString *const kThursdayKey;
extern NSString *const kFridayKey;
extern NSString *const kSaturdayKey;
extern NSString *const kSundayKey;
extern NSString *const kCourseKey;

+ (void)addTimeBlockWithCourseName:(NSString *)courseName courseNumber:(NSString *)courseNumber professorName:(NSString *)professorName startTime:(NSDate *)startTime endTime:(NSDate *)endTime monday:(BOOL)monday tuesday:(BOOL)tuesday wednesday:(BOOL)wednesday thursday:(BOOL)thursday friday:(BOOL)friday saturday:(BOOL)saturday sunday:(BOOL)sunday withCompletion:(void(^)(TimeBlock *timeBlock, NSError *error))completion;
+ (void)addTimeBlockWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime monday:(BOOL)monday tuesday:(BOOL)tuesday wednesday:(BOOL)wednesday thursday:(BOOL)thursday friday:(BOOL)friday saturday:(BOOL)saturday sunday:(BOOL)sunday withCompletion:(void(^)(TimeBlock *timeBlock, NSError *error))completion;
- (void)deleteExistingTimeBlockWithCompletion:(PFBooleanResultBlock)completion;
- (NSString *)getDaysString;
- (NSString *)getStartTimeString;
- (NSString *)getEndTimeString;
- (NSString *)getTimesString;
- (NSString *)getDurationString;

@end

NS_ASSUME_NONNULL_END
