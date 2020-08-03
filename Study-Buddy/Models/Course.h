//
//  Course.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Course : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseNumber;
@property (strong, nonatomic) NSString *professorName;
@property (strong, nonatomic) NSMutableArray *students;
extern NSString *const kCourseNameKey;
extern NSString *const kCourseNumberKey;
extern NSString *const kProfessorNameKey;
extern NSString *const kStudentsKey;

@end

NS_ASSUME_NONNULL_END
