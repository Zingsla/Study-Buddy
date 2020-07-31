//
//  CurrentBuddiesViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/21/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CurrentBuddiesViewController.h"
#import "Connection.h"
#import "PersonDetailsViewController.h"
#import "StudentCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface CurrentBuddiesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *buddies;

@end

@implementation CurrentBuddiesViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"Connection"];
    [query whereKey:@"users" equalTo:[User currentUser]];
    [query includeKey:@"users"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching current buddies: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched current buddies!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.buddies = [Connection getBuddiesArrayFromConnectionsArray:objects user:[User currentUser]];
                [strongSelf.tableView reloadData];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell"];
    cell.user = self.buddies[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddies.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *buddy = self.buddies[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        [Connection deleteConnectionWithUser:buddy andUser:[User currentUser] withBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error deleting connection: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully deleted connection!");
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.buddies removeObjectAtIndex:indexPath.row];
                    [strongSelf.tableView reloadData];
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                }
            }
        }];
    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *originalImage = [UIImage systemImageNamed:@"person.3"];
    return [UIImage imageWithCGImage:[originalImage CGImage] scale:(originalImage.scale * 0.5) orientation:originalImage.imageOrientation];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Current Buddies";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looks like you don't have any study buddies. Go check out your suggested buddies and add some!";
    
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
    if ([segue.identifier isEqualToString:@"CurrentBuddyDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        User *user = self.buddies[indexPath.row];
        PersonDetailsViewController *personDetailsViewController = [segue destinationViewController];
        personDetailsViewController.user = user;
    }
}

@end
