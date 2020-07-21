//
//  Connection.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/21/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Connection : PFObject<PFSubclassing>

@property (strong, nonatomic) NSArray *users;

+ (void)addConnectionWithUsers:(NSArray *)users;
+ (BOOL)connectionExistsWith:(NSArray *)users;

@end

NS_ASSUME_NONNULL_END
