//
//  ScheduleViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/14/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "ScheduleViewController.h"
#import "BlockoutCell.h"
#import "CourseCell.h"
#import "User.h"

@interface ScheduleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *timeBlocks;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:[User currentUser].username];
    [query includeKey:@"schedule"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching user data: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched user data!");
            User *user = objects[0];
            self.timeBlocks = user.schedule;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeBlock *timeBlock = self.timeBlocks[indexPath.row];
    if (timeBlock.course == nil) {
        BlockoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockoutCell"];
        return cell;
    } else {
        CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeBlocks.count;
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
