//
//  UIAlertController+Utils.h
//  Study-Buddy
//
//  Created by Jacob Franz on 8/3/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Utils)

+ (UIAlertController *)sendErrorWithTitle:(NSString *)title message:(NSString *)message;
+ (UIAlertController *)sendFormattedErrorWithTitle:(NSString *)title message:(NSString *)message error:(NSString *)error;

@end

NS_ASSUME_NONNULL_END
