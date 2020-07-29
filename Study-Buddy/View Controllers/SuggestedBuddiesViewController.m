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
#import <MBProgressHUD/MBProgressHUD.h>

@interface SuggestedBuddiesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *buddies;

@end

@implementation SuggestedBuddiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)fetchData {
    User *currentUser = [User currentUser];
    NSMutableArray *possibleBuddies = [[NSMutableArray alloc] init];
    
    PFQuery *query = [User query];
    [query includeKey:@"schedule"];
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
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell"];
    cell.user = user;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddies.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SuggestedBuddyDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        User *user = self.buddies[indexPath.row];
        PersonDetailsViewController *personDetailsViewController = [segue destinationViewController];
        personDetailsViewController.user = user;
    }
}

@end
