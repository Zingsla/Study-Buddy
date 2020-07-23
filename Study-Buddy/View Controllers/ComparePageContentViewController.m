//
//  ComparePageContentViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "ComparePageContentViewController.h"
#import "FreetimeCell.h"
#import "TimeBlock.h"

@interface ComparePageContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ComparePageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayLabel.text = self.dayText;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeBlock *block = self.freeTimes[indexPath.row];
    FreetimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreetimeCell"];
    cell.timeBlock = block;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.freeTimes.count;
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
