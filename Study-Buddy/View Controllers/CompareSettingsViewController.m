//
//  CompareSettingsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 8/7/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CompareSettingsViewController.h"
#import "DateTools.h"
#import "UIAlertController+Utils.h"

@interface CompareSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;

@end

@implementation CompareSettingsViewController

NSString *const kUserDefaultsStartTimeKey = @"startTime";
NSString *const kUserDefaultsEndTimeKey = @"endTime";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.startTimePicker.date = [defaults objectForKey:kUserDefaultsStartTimeKey];
    self.endTimePicker.date = [defaults objectForKey:kUserDefaultsEndTimeKey];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.startTimePicker.date forKey:kUserDefaultsStartTimeKey];
    [defaults setObject:self.endTimePicker.date forKey:kUserDefaultsEndTimeKey];
    [defaults synchronize];
}

- (IBAction)didTapSaveChanges:(id)sender {
    if ([self  startBeforeEnd]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.startTimePicker.date forKey:kUserDefaultsStartTimeKey];
        [defaults setObject:self.endTimePicker.date forKey:kUserDefaultsEndTimeKey];
        [defaults synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alert = [UIAlertController sendErrorWithTitle:@"Invalid Settings" message:@"Your selected end time is before your selected start time. Please select valid options and try again."];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)startBeforeEnd {
    NSDate *start = self.startTimePicker.date;
    NSDate *end = self.endTimePicker.date;
    
    if (start.hour < end.hour) {
        return YES;
    } else if (end.hour < start.hour) {
        return NO;
    } else {
        return (start.minute < end.minute);
    }
}

@end
