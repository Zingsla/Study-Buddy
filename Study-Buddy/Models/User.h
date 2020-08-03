//
//  User.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) PFFileObject *profileImage;
@property (strong, nonatomic) NSMutableArray *schedule;
@property (assign, nonatomic) BOOL facebookAccount;
extern NSString *const kUsernameKey;
extern NSString *const kScheduleKey;
extern CGFloat const kDefaultProfilePhotoSize;

- (NSString *)getYearString;
- (NSString *)getNameString;
- (NSComparisonResult)compare:(User *)otherUser;
- (NSInteger)numberOfSharedClassesWith:(User *)user;
- (NSArray *)compareScheduleWith:(User *)otherUser;
+ (PFFileObject *)getPFFileObjectFromImage:(UIImage * _Nullable)image;
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
