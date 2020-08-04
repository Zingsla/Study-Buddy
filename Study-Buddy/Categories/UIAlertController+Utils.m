//
//  UIAlertController+Utils.m
//  Study-Buddy
//
//  Created by Jacob Franz on 8/3/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "UIAlertController+Utils.h"

@implementation UIAlertController (Utils)

+ (UIAlertController *)sendErrorWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:dismissAction];
    return alert;
}

@end
