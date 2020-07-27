//
//  ScheduleViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "ScheduleViewController.h"
#import "BlockoutCell.h"
#import "BlockoutDetailsViewController.h"
#import "CourseCell.h"
#import "CourseDetailsViewController.h"
#import "User.h"

@interface ScheduleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *timeBlocks;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:[User currentUser].username];
    [query includeKey:@"schedule"];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching user data: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched user data!");
            User *user = objects[0];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [self.refreshControl endRefreshing];
                self.timeBlocks = user.schedule;
                [self.timeBlocks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    TimeBlock *block1 = obj1;
                    TimeBlock *block2 = obj2;
                    return [block2.createdAt compare:block1.createdAt];
                }];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeBlock *timeBlock = self.timeBlocks[indexPath.row];
    if (timeBlock.isClass) {
        CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
        cell.timeBlock = timeBlock;
        return cell;
    } else {
        BlockoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockoutCell"];
        cell.timeBlock = timeBlock;
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeBlocks.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimeBlock *block = self.timeBlocks[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [block deleteExistingTimeBlockWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error deleting timeblock: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully deleted timeblock!");
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [self.timeBlocks removeObjectAtIndex:indexPath.row];
                }
                [tableView reloadData];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeBlock *block = self.timeBlocks[indexPath.row];
    
    if (block.isClass) {
        CourseDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseDetailsViewController"];
        newView.timeBlock = block;
        [self.navigationController pushViewController:newView animated:YES];
    } else {
        BlockoutDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlockoutDetailsViewController"];
        newView.timeBlock = block;
        [self.navigationController pushViewController:newView animated:YES];
    }
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
