//
//  PersonDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/20/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "CompareScheduleViewController.h"
#import "Connection.h"
#import "CourseCell.h"
#import "CourseDetailsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MBProgressHUD/MBProgressHUD.h>
@import Parse;

@interface PersonDetailsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buddyStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBuddyButton;
@property (weak, nonatomic) IBOutlet UIButton *removeBuddyButton;
@property (strong, nonatomic) NSMutableArray *schedule;

@end

@implementation PersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [self.user getNameString];
    self.yearLabel.text = [self.user getYearString];
    self.majorLabel.text = self.user.major;
    self.emailLabel.text = self.user.emailAddress;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    [self.profileImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.profileImage.layer setBorderWidth:2];
    if (self.user.profileImage != nil) {
        self.profileImage.file = self.user.profileImage;
        [self.profileImage loadInBackground];
    }
    [self checkBuddyStatus];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.schedule = self.user.schedule;
    [self.tableView reloadData];
}

- (void)checkBuddyStatus {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Connection connectionExistsWithUser:self.user andUser:[User currentUser]]) {
        self.buddyStatusLabel.text = @"Currently buddies!";
        self.addBuddyButton.hidden = YES;
        self.removeBuddyButton.hidden = NO;
    } else {
        self.buddyStatusLabel.text = @"Not currently buddies";
        self.addBuddyButton.hidden = NO;
        self.removeBuddyButton.hidden = YES;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)didTapAddBuddy:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [Connection addConnectionWithUser:self.user andUser:[User currentUser] withBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error creating connection: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully created connection!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [strongSelf checkBuddyStatus];
            }
        }
    }];
}

- (IBAction)didTapRemoveBuddy:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [Connection deleteConnectionWithUser:self.user andUser:[User currentUser] withBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error removing buddy: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully removed buddy!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [strongSelf checkBuddyStatus];
            }
        }
    }];
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

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *originalImage = [UIImage systemImageNamed:@"calendar"];
    return [UIImage imageWithCGImage:[originalImage CGImage] scale:(originalImage.scale * 0.5) orientation:originalImage.imageOrientation];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Courses";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Looks like this user doesn't have any courses addded. Check back later!";
    
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
    if ([segue.identifier isEqualToString:@"CompareSegue"]) {
        CompareScheduleViewController *compareScheduleViewController = [segue destinationViewController];
        compareScheduleViewController.user = self.user;
    }
}

@end
