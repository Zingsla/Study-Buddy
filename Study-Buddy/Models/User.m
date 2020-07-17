//
//  User.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic firstName;
@dynamic lastName;
@dynamic major;
@dynamic year;
@dynamic profileImage;
@dynamic schedule;
@dynamic buddies;

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

@end
