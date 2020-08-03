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
NSString *const kUsersKey = @"users";

+ (nonnull NSString *)parseClassName {
    return @"Connection";
}

#pragma mark - Creation

+ (void)addConnectionWithUser:(User *)user1 andUser:(User *)user2 withBlock:(PFBooleanResultBlock)completion {
    if ([self connectionExistsWithUser:user1 andUser:user2]) {
        return;
    }
    
    Connection *connection = [Connection new];
    User *users[2];
    users[0] = user1;
    users[1] = user2;
    connection.users = [NSArray arrayWithObjects:users count:2];
    [connection saveInBackgroundWithBlock:completion];
}

#pragma mark - Query

+ (BOOL)connectionExistsWithUser:(User *)user1 andUser:(User *)user2 {
    User *users[2];
    users[0] = user1;
    users[1] = user2;
    NSArray *usersArray = [NSArray arrayWithObjects:users count:2];
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass(Connection.class)];
    [query whereKey:kUsersKey containsAllObjectsInArray:usersArray];
    NSArray *connections = [query findObjects];
    return (connections.count > 0);
}

+ (Connection *)getExistingConnectionWithUser:(User *)user1 andUser:(User *)user2 {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass(Connection.class)];
    [query whereKey:kUsersKey containsAllObjectsInArray:[NSArray arrayWithObjects:user1, user2, nil]];
    return [query findObjects][0];
}

#pragma mark - Deletion

+ (void)deleteConnectionWithUser:(User *)user1 andUser:(User *)user2 withBlock:(PFBooleanResultBlock)completion {
    if ([Connection connectionExistsWithUser:user1 andUser:user2]) {
        Connection *connection = [Connection getExistingConnectionWithUser:user1 andUser:user2];
        [connection deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                completion(NO, error);
            } else {
                completion(YES, nil);
            }
        }];
    } else {
        NSLog(@"Doing nothing, connection does not exist");
    }
}

#pragma mark - Helper Methods

+ (NSMutableArray *)getBuddiesArrayFromConnectionsArray:(NSArray *)connections user:(User *)user {
    NSMutableArray *buddies = [[NSMutableArray alloc] init];
    for (Connection *connection in connections) {
        [buddies addObject:[connection getOtherUserFrom:user]];
    }
    
    return buddies;
}

- (User *)getOtherUserFrom:(User *)user {
    if ([self.users[0] isEqual:[User currentUser]]) {
        return self.users[1];
    } else {
        return self.users[0];
    }
}

@end
