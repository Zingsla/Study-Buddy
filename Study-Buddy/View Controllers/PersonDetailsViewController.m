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
#import "SignupViewController.h"
#import "UIAlertController+Utils.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MessageUI/MessageUI.h>
@import Parse;

@interface PersonDetailsViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buddyStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UILabel *emailHiddenLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBuddyButton;
@property (weak, nonatomic) IBOutlet UIButton *removeBuddyButton;
@property (strong, nonatomic) NSMutableArray *schedule;

@end

@implementation PersonDetailsViewController

NSString *const kCompareSegueIdentifier = @"CompareSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [self.user getNameString];
    self.yearLabel.text = [self.user getYearString];
    self.majorLabel.text = self.user.major;
    [self.emailButton setTitle:self.user.emailAddress forState:UIControlStateNormal];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    [self.profileImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.profileImage.layer setBorderWidth:kProfilePhotoBorderSize];
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
        if ([self.user.emailPrivacy intValue] == 2) {
            self.emailButton.alpha = 0;
            self.emailHiddenLabel.alpha = 1;
        } else {
            self.emailHiddenLabel.alpha = 0;
            self.emailButton.alpha = 1;
        }
    } else {
        self.buddyStatusLabel.text = @"Not currently buddies";
        self.addBuddyButton.hidden = NO;
        self.removeBuddyButton.hidden = YES;
        if ([self.user.emailPrivacy intValue] == 0) {
            self.emailHiddenLabel.alpha = 0;
            self.emailButton.alpha = 1;
        } else {
            self.emailButton.alpha = 0;
            self.emailHiddenLabel.alpha = 1;
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Add Buddy

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

#pragma mark - Remove Buddy

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

#pragma mark - Email Composition

- (IBAction)didTapEmail:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are unavailable");
        UIAlertController *alert = [UIAlertController sendErrorWithTitle:@"Mail Error" message:@"Unable to send an email to this user. Please try again later."];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    [composeVC setToRecipients:@[self.emailButton.titleLabel.text]];
    [composeVC setSubject:@"Study Buddy Request"];
    [composeVC setMessageBody:@"Hi there! I found your profile through Study Buddy and would like to reach out to you!" isHTML:NO];
    
    [self presentViewController:composeVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CourseCell.class)];
    cell.timeBlock = self.schedule[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schedule.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeBlock *block = self.schedule[indexPath.row];
    
    CourseDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(CourseDetailsViewController.class)];
    newView.timeBlock = block;
    [self.navigationController pushViewController:newView animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:kCompareSegueIdentifier]) {
        CompareScheduleViewController *compareScheduleViewController = [segue destinationViewController];
        compareScheduleViewController.user = self.user;
    }
}

@end
