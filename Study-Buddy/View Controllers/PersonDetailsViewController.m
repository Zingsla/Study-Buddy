//
//  PersonDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/20/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "PersonDetailsViewController.h"

@interface PersonDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buddyStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation PersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [self.user getNameString];
    self.yearLabel.text = [self.user getYearString];
    self.majorLabel.text = self.user.major;
    self.emailLabel.text = self.user.emailAddress;
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
