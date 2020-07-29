//
//  LoginViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "User.h"
#import <PFFacebookUtils.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (assign, nonatomic) BOOL facebookSignup;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.facebookSignup = NO;
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    __weak typeof(self) weakSelf = self;
    [User logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error logging in user: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully logged in user!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
            }
        }
    }];
}

- (IBAction)didTapLoginWithFacebook:(id)sender {
    NSArray *permissions = @[@"email", @"public_profile"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error logging in with Facebook: %@", error.localizedDescription);
        } else if (!user) {
            NSLog(@"User cancelled Facebook login");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Facebook!");
            self.facebookSignup = YES;
            [self performSelector:@selector(transitionToSignup) withObject:nil afterDelay:0.5];
        } else {
            NSLog(@"User successfully logged in with Facebook!");
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
    }];
}

- (void)transitionToSignup {
    SignupViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    newView.signingUpWithFacebook = YES;
    [self performSegueWithIdentifier:@"LoginToSignupSegue" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginToSignupSegue"]) {
        SignupViewController *signupViewController = [segue destinationViewController];
        signupViewController.signingUpWithFacebook = self.facebookSignup;
    }
}

@end
