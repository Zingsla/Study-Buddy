//
//  TimeblockCreateViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "TimeblockCreateViewController.h"
#import "TimeBlock.h"

@interface TimeblockCreateViewController ()

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
    // Do any additional setup after loading the view.
}

- (IBAction)didTapAdd:(id)sender {
    [TimeBlock addTimeBlockWithCourseName:self.courseNameField.text courseNumber:self.courseNumberField.text professorName:self.professorNameField.text startTime:self.startTimePicker.date endTime:self.endTimePicker.date monday:self.mondaySwitch.on tuesday:self.tuesdaySwitch.on wednesday:self.wednesdaySwitch.on thursday:self.thursdaySwitch.on friday:self.fridaySwitch.on saturday:self.saturdaySwitch.on sunday:self.sundaySwitch.on withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error creating new timeblock: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully added new timeblock!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
