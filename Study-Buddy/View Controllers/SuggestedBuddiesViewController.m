//
//  SuggestedBuddiesViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/22/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "SuggestedBuddiesViewController.h"
#import "Connection.h"
#import "PersonDetailsViewController.h"
#import "StudentCell.h"
#import "User.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface SuggestedBuddiesViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *buddies;

@end

@implementation SuggestedBuddiesViewController

NSString *const kSuggestedBuddyDetailsSegueIdentifier = @"SuggestedBuddyDetailsSegue";

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

#pragma mark - Data Query

- (void)fetchData {
    User *currentUser = [User currentUser];
    NSMutableArray *possibleBuddies = [[NSMutableArray alloc] init];
    
    PFQuery *query = [User query];
    [query includeKey:kScheduleKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching users: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched all users!");
            
            for (User *user in objects) {
                if (![user.username isEqualToString:currentUser.username] && ![Connection connectionExistsWithUser:user andUser:currentUser] && [user numberOfSharedClassesWith:currentUser] > 0) {
                    [possibleBuddies addObject:user];
                }
            }
            
            [possibleBuddies sortUsingSelector:@selector(compare:)];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.buddies = possibleBuddies;
                [strongSelf.tableView reloadData];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.buddies[indexPath.row];
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(StudentCell.class)];
    cell.user = user;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddies.count;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *originalImage = [UIImage systemImageNamed:@"person.3"];
    return [UIImage imageWithCGImage:[originalImage CGImage] scale:(originalImage.scale * 0.5) orientation:originalImage.imageOrientation];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Suggested Buddies";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looks like we can't find any suggested buddies for you. That means that there are no other users that share a class with you that you aren't already buddies with!";
    
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
    if ([segue.identifier isEqualToString:kSuggestedBuddyDetailsSegueIdentifier]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        User *user = self.buddies[indexPath.row];
        PersonDetailsViewController *personDetailsViewController = [segue destinationViewController];
        personDetailsViewController.user = user;
    }
}

@end
