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

@interface CurrentBuddiesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *buddies;

@end

@implementation CurrentBuddiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"Connection"];
    [query whereKey:@"users" equalTo:[User currentUser]];
    [query includeKey:@"users"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching current buddies: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched current buddies!");
            self.buddies = [Connection getBuddiesArrayFromConnectionsArray:objects user:[User currentUser]];
            [self.tableView reloadData];
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
