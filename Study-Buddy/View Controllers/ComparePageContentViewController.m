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
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface ComparePageContentViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ComparePageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayLabel.text = self.dayText;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
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

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *originalImage = [UIImage systemImageNamed:@"calendar"];
    return [UIImage imageWithCGImage:[originalImage CGImage] scale:(originalImage.scale * 0.5) orientation:originalImage.imageOrientation];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Shared Freetimes";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looks like there are no shared freetimes on this day. You must have some busy schedules!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
