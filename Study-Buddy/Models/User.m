//
//  User.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "User.h"
#import "CompareSettingsViewController.h"
#import "DateTools.h"
#import "TimeBlock.h"

@implementation User

@dynamic firstName;
@dynamic lastName;
@dynamic emailAddress;
@dynamic major;
@dynamic year;
@dynamic profileImage;
@dynamic schedule;
@dynamic facebookAccount;
@dynamic emailPrivacy;
NSString *const kScheduleKey = @"schedule";
NSString *const kUsernameKey = @"username";
CGFloat const kDefaultProfilePhotoSize = 512;

+ (User *)user {
    return (User *)[PFUser user];
}

- (NSString *)getYearString {
    if ([self.year isEqualToNumber:@(1)]) {
        return @"Freshman";
    } else if ([self.year isEqualToNumber:@(2)]) {
        return @"Sophomore";
    } else if ([self.year isEqualToNumber:@(3)]) {
        return @"Junior";
    } else if ([self.year isEqualToNumber:@(4)]) {
        return @"Senior";
    } else {
        return @"";
    }
}

- (NSString *)getNameString {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSMutableSet *)scheduleSet {
    return [NSMutableSet setWithArray:self.schedule];
}

#pragma mark - User Comparison

- (NSComparisonResult)compare:(User *)otherUser {
    if ([self compareSharedClassesWithUser:otherUser] != NSOrderedSame) {
        return [self compareSharedClassesWithUser:otherUser];
    }
    
    if ([self compareMajorsWithUser:otherUser] != NSOrderedSame) {
        return [self compareMajorsWithUser:otherUser];
    }
    
    return [self compareYearsWithUser:otherUser];
}

- (NSComparisonResult)compareSharedClassesWithUser:(User *)otherUser {
    User *currentUser = [User currentUser];
    NSInteger sharedSelf = [self numberOfSharedClassesWith:currentUser];
    NSInteger sharedOther = [otherUser numberOfSharedClassesWith:currentUser];
    
    if (sharedSelf > sharedOther) {
        return NSOrderedAscending;
    } else if (sharedOther > sharedSelf) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareMajorsWithUser:(User *)otherUser {
    User *currentUser = [User currentUser];
    BOOL majorMatchSelf = [self.major isEqualToString:currentUser.major];
    BOOL majorMatchOther = [otherUser.major isEqualToString:currentUser.major];
    
    if (majorMatchSelf && !majorMatchOther) {
        return NSOrderedAscending;
    } else if (majorMatchOther && !majorMatchSelf) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareYearsWithUser:(User *)otherUser {
    User *currentUser = [User currentUser];
    NSInteger yearDifferenceSelf = labs([self.year integerValue] - [currentUser.year integerValue]);
    NSInteger yearDifferenceOther = labs([otherUser.year integerValue] - [currentUser.year integerValue]);
    
    if (yearDifferenceSelf < yearDifferenceOther) {
        return NSOrderedAscending;
    } else if (yearDifferenceOther < yearDifferenceSelf) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSInteger)numberOfSharedClassesWith:(User *)user {
    NSMutableSet *intersection = [NSMutableSet setWithSet:[self scheduleSet]];
    [intersection intersectSet:[user scheduleSet]];
    return [intersection count];
}

#pragma mark - Schedule Comparison

- (NSArray *)compareScheduleWith:(User *)otherUser {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results addObject:[self compareDay:kMondayKey withUser:otherUser]];
    [results addObject:[self compareDay:kTuesdayKey withUser:otherUser]];
    [results addObject:[self compareDay:kWednesdayKey withUser:otherUser]];
    [results addObject:[self compareDay:kThursdayKey withUser:otherUser]];
    [results addObject:[self compareDay:kFridayKey withUser:otherUser]];
    [results addObject:[self compareDay:kSaturdayKey withUser:otherUser]];
    [results addObject:[self compareDay:kSundayKey withUser:otherUser]];
    return [NSArray arrayWithArray:results];
}

- (NSArray *)compareDay:(NSString *)day withUser:(User *)otherUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *startTime = [defaults objectForKey:kUserDefaultsStartTimeKey];
    NSDate *endTime = [defaults objectForKey:kUserDefaultsEndTimeKey];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.timeZone = [NSTimeZone systemTimeZone];
    components.year = today.year;
    components.month = today.month;
    components.day = today.day;
    components.hour = startTime.hour;
    components.minute = startTime.minute;
    components.second = 0;
    NSDate *baseStartDate = [gregorian dateFromComponents:components];
    components.hour = endTime.hour;
    components.minute = endTime.minute;
    NSDate *baseEndDate = [gregorian dateFromComponents:components];
        
    NSMutableArray *busyPeriods = [[NSMutableArray alloc] init];
    [busyPeriods addObjectsFromArray:[self getTimePeriodsForDay:day]];
    [busyPeriods addObjectsFromArray:[otherUser getTimePeriodsForDay:day]];
    NSMutableArray *sharedFreeTimes = [[NSMutableArray alloc] init];
    
    DTTimePeriod *period = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMinute amount:30 startingAt:baseStartDate];
    // Continue looping until past end time
    while ([period.EndDate isEarlierThanOrEqualTo:baseEndDate]) {
        BOOL hadConflict = NO;
        
        // Compare current time period to all busy periods
        for (DTTimePeriod *busyPeriod in busyPeriods) {
            if ([period overlapsWith:busyPeriod]) {
                // Current period overlaps with a busy period
                // Recreate the previous time period and check if it had a length greater than 0
                DTTimePeriod *previousPeriod = [DTTimePeriod timePeriodWithStartDate:period.StartDate endDate:period.EndDate];
                [previousPeriod shortenWithAnchorDate:DTTimePeriodAnchorStart size:DTTimePeriodSizeMinute amount:30];
                if (![previousPeriod.StartDate isEqualToDate:previousPeriod.EndDate]) {
                    // Previous time period was valid, add it
                    TimeBlock *block = [TimeBlock new];
                    block.startTime = previousPeriod.StartDate;
                    block.endTime = previousPeriod.EndDate;
                    [sharedFreeTimes addObject:block];
                }
                // Move on to next time period
                period = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMinute amount:30 startingAt:period.EndDate];
                hadConflict = YES;
                break;
            }
        }
        
        if (!hadConflict) {
            if ([period.EndDate isEqualToDate:baseEndDate]) {
                // End of the day, add freetime
                TimeBlock *block = [TimeBlock new];
                block.startTime = period.StartDate;
                block.endTime = period.EndDate;
                [sharedFreeTimes addObject:block];
            }
            // Never overlapped with a busy period, extend period
            [period lengthenWithAnchorDate:DTTimePeriodAnchorStart size:DTTimePeriodSizeMinute amount:30];
        }
    }
    
    return sharedFreeTimes;
}

- (NSMutableArray *)getTimePeriodsForDay:(NSString *)day {
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (TimeBlock *block in self.schedule) {
        [block fetchIfNeeded];
        if ([block[day] boolValue]) {
            NSDateComponents *startComponents = [[NSDateComponents alloc] init];
            startComponents.year = today.year;
            startComponents.month = today.month;
            startComponents.day = today.day;
            startComponents.hour = block.startTime.hour;
            startComponents.minute = block.startTime.minute;
            startComponents.second = 0;
            NSDate *start = [gregorian dateFromComponents:startComponents];
            
            NSDateComponents *endComponents = [[NSDateComponents alloc] init];
            endComponents.year = today.year;
            endComponents.month = today.month;
            endComponents.day = today.day;
            endComponents.hour = block.endTime.hour;
            endComponents.minute = block.endTime.minute;
            endComponents.second = 0;
            NSDate *end = [gregorian dateFromComponents:endComponents];
            
            DTTimePeriod *period = [DTTimePeriod timePeriodWithStartDate:start endDate:end];
            [results addObject:period];
        }
    }
    
    return results;
}

#pragma mark - Image Helper Functions

+ (PFFileObject *)getPFFileObjectFromImage:(UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
                             
@end
