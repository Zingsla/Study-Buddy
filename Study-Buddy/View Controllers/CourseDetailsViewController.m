//
//  CourseDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/16/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "StudentCell.h"

@interface CourseDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *professorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *students;

@end

@implementation CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.courseNameLabel.text = self.timeBlock.course.courseName;
    self.courseNumberLabel.text = self.timeBlock.course.courseNumber;
    self.professorNameLabel.text = self.timeBlock.course.professorName;
    self.timeLabel.text = [self.timeBlock getTimesString];
    self.daysLabel.text = [self.timeBlock getDaysString];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchData];
}

- (void)fetchData {
    self.students = self.timeBlock.course.students;
    User *toRemove;
    for (User *user in self.students) {
        if ([user.objectId isEqualToString:[User currentUser].objectId]) {
            toRemove = user;
        }
    }
    [self.students removeObject:toRemove];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell"];
    cell.user = self.students[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.students.count;
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
