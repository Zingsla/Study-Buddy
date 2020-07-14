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
