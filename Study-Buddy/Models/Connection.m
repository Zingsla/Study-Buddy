//
//  Connection.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/21/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "Connection.h"

@implementation Connection

@dynamic users;

+ (nonnull NSString *)parseClassName {
    return @"Connection";
}

+ (void)addConnectionWithUser:(User *)user1 andUser:(User *)user2 withBlock:(PFBooleanResultBlock)completion {
    if ([self connectionExistsWithUser:user1 andUser:user2]) {
        return;
    }
    
    Connection *connection = [Connection new];
    connection.users = [NSArray arrayWithObjects:user1, user2, nil];
    [connection saveInBackgroundWithBlock:completion];
}

+ (BOOL)connectionExistsWithUser:(User *)user1 andUser:(User *)user2 {
    NSArray *users = [NSArray arrayWithObjects:user1, user2, nil];
    PFQuery *query = [PFQuery queryWithClassName:@"Connection"];
    [query whereKey:@"users" containsAllObjectsInArray:users];
    NSArray *connections = [query findObjects];
    return (connections.count > 0);
}

@end
