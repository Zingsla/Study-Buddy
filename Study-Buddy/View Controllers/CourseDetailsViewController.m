//
//  CourseDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/16/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CourseDetailsViewController.h"

@interface CourseDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *professorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@end

@implementation CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.courseNameLabel.text = self.timeBlock.course.courseName;
    self.courseNumberLabel.text = self.timeBlock.course.courseNumber;
    self.professorNameLabel.text = self.timeBlock.course.professorName;
    self.timeLabel.text = [self.timeBlock getTimesString];
    self.daysLabel.text = [self.timeBlock getDaysString];
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
