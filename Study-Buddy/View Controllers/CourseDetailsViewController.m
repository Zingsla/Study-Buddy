//
//  CourseDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/16/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "PersonDetailsViewController.h"
#import "StudentCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface CourseDetailsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

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
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    
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

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *originalImage = [UIImage systemImageNamed:@"person.3"];
    return [UIImage imageWithCGImage:[originalImage CGImage] scale:(originalImage.scale * 0.5) orientation:originalImage.imageOrientation];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Other Students";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looks like we there are no other users that are in this class. Check back later and see if somebody new joined!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PersonDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        User *user = self.students[indexPath.row];
        PersonDetailsViewController *personDetailsViewController = [segue destinationViewController];
        personDetailsViewController.user = user;
    }
}

@end
