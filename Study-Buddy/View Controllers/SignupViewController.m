//
//  SignupViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "SignupViewController.h"
#import "User.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearControl;


@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignup:(id)sender {
    User *newUser = [User new];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    newUser.emailAddress = self.emailField.text;
    newUser.firstName = self.firstNameField.text;
    newUser.lastName = self.lastNameField.text;
    newUser.major = self.majorField.text;
    newUser.year = [NSNumber numberWithInteger:(self.yearControl.selectedSegmentIndex + 1)];
    newUser.schedule = [[NSMutableArray alloc] init];
    newUser.buddies = [[NSMutableArray alloc] init];
    
    if ([self allFieldsFilled]) {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error signing up user: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully signed up new user!");
                [self performSegueWithIdentifier:@"SignupSegue" sender:nil];
            }
        }];
    } else {
        NSLog(@"At least one field has not been filled in");
    }
}

- (BOOL)allFieldsFilled {
    return (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.firstNameField.text isEqualToString:@""] && ![self.lastNameField.text isEqualToString:@""] && ![self.majorField.text isEqualToString:@""]);
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
