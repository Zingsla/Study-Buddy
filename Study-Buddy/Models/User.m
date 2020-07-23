//
//  User.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "User.h"
#import "TimeBlock.h"

@implementation User

@dynamic firstName;
@dynamic lastName;
@dynamic emailAddress;
@dynamic major;
@dynamic year;
@dynamic profileImage;
@dynamic schedule;

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

- (NSComparisonResult)compare:(User *)otherUser {
    User *currentUser = [User currentUser];
    NSInteger sharedSelf = [self numberOfSharedClassesWith:currentUser];
    NSInteger sharedOther = [otherUser numberOfSharedClassesWith:currentUser];
    
    if (sharedSelf > sharedOther) {
        return NSOrderedAscending;
    } else if (sharedOther > sharedSelf) {
        return NSOrderedDescending;
    } else {
        BOOL majorMatchSelf = [self.major isEqualToString:currentUser.major];
        BOOL majorMatchOther = [otherUser.major isEqualToString:currentUser.major];
        if (majorMatchSelf && !majorMatchOther) {
            return NSOrderedAscending;
        } else if (majorMatchOther && !majorMatchSelf) {
            return NSOrderedDescending;
        } else {
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
    }
}


- (NSInteger)numberOfSharedClassesWith:(User *)user {
    NSInteger count = 0;
    for (TimeBlock *block in self.schedule) {
        for (TimeBlock *otherBlock in user.schedule) {
            if ([block.objectId isEqualToString:otherBlock.objectId]) {
                count++;
            }
        }
    }
    
    return count;
}

@end
