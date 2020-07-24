//
//  ProfileViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/15/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "User.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearControl;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (assign, nonatomic) BOOL inEditMode;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    self.nameLabel.text = [user getNameString];
    self.yearLabel.text = [user getYearString];
    self.majorLabel.text = user.major;
    self.emailLabel.text = user.email;
    self.inEditMode = NO;
}

- (IBAction)didTapLogout:(id)sender {
    [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error logging out: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully logged out!");
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            myDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (IBAction)didTapEdit:(id)sender {
    User *user = [User currentUser];
    
    if (!self.inEditMode) {
        self.nameLabel.hidden = YES;
        self.yearLabel.hidden = YES;
        self.majorLabel.hidden = YES;
        self.emailLabel.hidden = YES;
        self.firstNameField.text = user.firstName;
        self.firstNameField.hidden = NO;
        self.lastNameField.text = user.lastName;
        self.lastNameField.hidden = NO;
        self.yearControl.selectedSegmentIndex = user.year.intValue - 1;
        self.yearControl.hidden = NO;
        self.majorField.text = user.major;
        self.majorField.hidden = NO;
        self.emailAddressField.text = user.email;
        self.emailAddressField.hidden = NO;
        self.editButton.title = @"Save Changes";
        self.inEditMode = YES;
    } else {
        user.firstName = self.firstNameField.text;
        user.lastName = self.lastNameField.text;
        user.year = [NSNumber numberWithInteger:(self.yearControl.selectedSegmentIndex + 1)];
        user.major = self.majorField.text;
        user.email = self.emailAddressField.text;
        user.emailAddress = self.emailAddressField.text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error saving user changes: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully saved user changes!");
                self.firstNameField.hidden = YES;
                self.lastNameField.hidden = YES;
                self.yearControl.hidden = YES;
                self.majorField.hidden = YES;
                self.emailAddressField.hidden = YES;
                self.nameLabel.text = [user getNameString];
                self.nameLabel.hidden = NO;
                self.yearLabel.text = [user getYearString];
                self.yearLabel.hidden = NO;
                self.majorLabel.text = user.major;
                self.majorLabel.hidden = NO;
                self.emailLabel.text = user.email;
                self.emailLabel.hidden = NO;
                self.editButton.title = @"Edit";
                self.inEditMode = NO;
            }
        }];
    }
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
