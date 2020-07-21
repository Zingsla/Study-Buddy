//
//  PersonDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/20/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "CourseCell.h"
#import "CourseDetailsViewController.h"

@interface PersonDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buddyStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *schedule;

@end

@implementation PersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [self.user getNameString];
    self.yearLabel.text = [self.user getYearString];
    self.majorLabel.text = self.user.major;
    self.emailLabel.text = self.user.emailAddress;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.schedule = self.user.schedule;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    cell.timeBlock = self.schedule[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schedule.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeBlock *block = self.schedule[indexPath.row];
    
    CourseDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseDetailsViewController"];
    newView.timeBlock = block;
    [self.navigationController pushViewController:newView animated:YES];
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
