//
//  TimeblockCreateViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "TimeblockCreateViewController.h"
#import "DateTools.h"
#import "ProfileViewController.h"
#import "UIAlertController+Utils.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const errorTitle = @"Timeblock Creation Error";

@interface TimeblockCreateViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (weak, nonatomic) IBOutlet UISwitch *mondaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tuesdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wednesdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *thursdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fridaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saturdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sundaySwitch;
@property (weak, nonatomic) IBOutlet UITextField *courseNameField;
@property (weak, nonatomic) IBOutlet UITextField *courseNumberField;
@property (weak, nonatomic) IBOutlet UITextField *professorNameField;

@end

@implementation TimeblockCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didChangeType:(id)sender {
    if (self.typeControl.selectedSegmentIndex == 1) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.courseNameField.alpha = 0;
            self.courseNumberField.alpha = 0;
            self.professorNameField.alpha = 0;
        } completion:^(BOOL finished) {
            self.courseNameField.text = @"";
            self.courseNumberField.text = @"";
            self.professorNameField.text = @"";
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.courseNameField.alpha = 1;
            self.courseNumberField.alpha = 1;
            self.professorNameField.alpha = 1;
        }];
    }
}

#pragma mark - Creation

- (IBAction)didTapAdd:(id)sender {
    if ([self validateTimeblock]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.typeControl.selectedSegmentIndex == 0) {
            __weak typeof(self) weakSelf = self;
            [TimeBlock addTimeBlockWithCourseName:self.courseNameField.text courseNumber:self.courseNumberField.text professorName:self.professorNameField.text startTime:self.startTimePicker.date endTime:self.endTimePicker.date monday:self.mondaySwitch.on tuesday:self.tuesdaySwitch.on wednesday:self.wednesdaySwitch.on thursday:self.thursdaySwitch.on friday:self.fridaySwitch.on saturday:self.saturdaySwitch.on sunday:self.sundaySwitch.on withCompletion:^(TimeBlock *timeBlock, NSError *error) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    if (error != nil) {
                        NSLog(@"Error creating new course timeblock: %@", error.localizedDescription);
                        UIAlertController *alert = [UIAlertController sendFormattedErrorWithTitle:errorTitle message:@"An error occurred while creating this timeblock." error:error.localizedDescription];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    } else {
                        NSLog(@"Successfully added new course timeblock!");
                        [strongSelf.delegate didCreateTimeblock:timeBlock];
                        [strongSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }];
        } else {
            __weak typeof(self) weakSelf = self;
            [TimeBlock addTimeBlockWithStartTime:self.startTimePicker.date endTime:self.endTimePicker.date monday:self.mondaySwitch.on tuesday:self.tuesdaySwitch.on wednesday:self.wednesdaySwitch.on thursday:self.thursdaySwitch.on friday:self.fridaySwitch.on saturday:self.saturdaySwitch.on sunday:self.sundaySwitch.on withCompletion:^(TimeBlock *timeBlock, NSError *error) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    if (error != nil) {
                        NSLog(@"Error creating new blockout timeblock: %@", error.localizedDescription);
                        UIAlertController *alert = [UIAlertController sendFormattedErrorWithTitle:errorTitle message:@"An error occurred while creating this timeblock." error:error.localizedDescription];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    } else {
                        NSLog(@"Successfully added new blockout timeblock!");
                        [strongSelf.delegate didCreateTimeblock:timeBlock];
                        [strongSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }];
        }
    }
}

#pragma mark - Validation

- (BOOL)validateTimeblock {
    if (![self allFieldsFilled]) {
        UIAlertController *alert = [UIAlertController sendErrorWithTitle:errorTitle message:@"At least one required field has not been filled in. Please ensure all fields are filled and try again."];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else if (![self atLeastOneDaySelected]) {
        UIAlertController *alert = [UIAlertController sendErrorWithTitle:errorTitle message:@"No days have been selected for this timeblock. Please select at least one day and try again."];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else if (![self startBeforeEnd]) {
        UIAlertController *alert = [UIAlertController sendErrorWithTitle:errorTitle message:@"Start time occurs after end time. Please select a valid start and end time and try again."];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)allFieldsFilled {
    if (self.typeControl.selectedSegmentIndex == 0) {
        return (![self.courseNameField.text isEqualToString:@""] && ![self.courseNumberField.text isEqualToString:@""] && ![self.professorNameField.text isEqualToString:@""]);
    } else {
        return YES;
    }
}

- (BOOL)atLeastOneDaySelected {
    return (self.mondaySwitch.on || self.tuesdaySwitch.on || self.wednesdaySwitch.on || self.thursdaySwitch.on || self.fridaySwitch.on || self.saturdaySwitch.on || self.sundaySwitch.on);
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

#pragma mark - Navigation

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
