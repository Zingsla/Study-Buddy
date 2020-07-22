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

+ (void)addConnectionWithUser:(User *)user1 andUser:(User *)user2 withBlock:(PFBooleanResultBlock)completion;
+ (BOOL)connectionExistsWithUser:(User *)user1 andUser:(User *)user2;
+ (NSMutableArray *)getBuddiesArrayFromConnectionsArray:(NSArray *)connections user:(User *)user;

@end

NS_ASSUME_NONNULL_END
