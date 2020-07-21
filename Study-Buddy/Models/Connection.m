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

+ (void)addConnectionWithUsers:(NSArray *)users {
    if ([self connectionExistsWith:users]) {
        return;
    }
    
    Connection *connection = [Connection new];
    connection.users = [NSArray arrayWithArray:users];
    [connection saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error saving connection: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved connection!");
        }
    }];
}

+ (BOOL)connectionExistsWith:(NSArray *)users {
    PFQuery *query = [PFQuery queryWithClassName:@"Connection"];
    [query whereKey:@"users" containsAllObjectsInArray:users];
    NSArray *connections = [query findObjects];
    return (connections.count > 0);
}

@end
