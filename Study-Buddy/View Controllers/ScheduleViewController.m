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
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ScheduleViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *timeBlocks;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [User query];
    [query whereKey:kUsernameKey equalTo:[User currentUser].username];
    [query includeKey:kScheduleKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching user data: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched user data!");
            User *user = objects[0];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.timeBlocks = user.schedule;
                [strongSelf.timeBlocks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    TimeBlock *block1 = obj1;
                    TimeBlock *block2 = obj2;
                    return [block2.createdAt compare:block1.createdAt];
                }];
                [strongSelf.tableView reloadData];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeBlock *timeBlock = self.timeBlocks[indexPath.row];
    if (timeBlock.isClass) {
        CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CourseCell.class)];
        cell.timeBlock = timeBlock;
        return cell;
    } else {
        BlockoutCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BlockoutCell.class)];
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        [block deleteExistingTimeBlockWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error deleting timeblock: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully deleted timeblock!");
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.timeBlocks removeObjectAtIndex:indexPath.row];
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
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
        CourseDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(CourseDetailsViewController.class)];
        newView.timeBlock = block;
        [self.navigationController pushViewController:newView animated:YES];
    } else {
        BlockoutDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(BlockoutDetailsViewController.class)];
        newView.timeBlock = block;
        [self.navigationController pushViewController:newView animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *originalImage = [UIImage systemImageNamed:@"calendar"];
    return [UIImage imageWithCGImage:[originalImage CGImage] scale:(originalImage.scale * 0.5) orientation:originalImage.imageOrientation];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Empty Schedule";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looks like you don't have anything in your schedule yet. Press the \"+\" button in the top right corner to add something!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

@end
