//
//  LoginViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "UIAlertController+Utils.h"
#import "User.h"
#import <ChameleonFramework/Chameleon.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <PFFacebookUtils.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (assign, nonatomic) BOOL facebookSignup;

@end

@implementation LoginViewController

NSString *const kLoginSegueIdentifier = @"LoginSegue";
NSString *const kLoginToSignupSegueIdentifier = @"LoginToSignupSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame andColors:@[[UIColor flatGreenColor], [UIColor flatMintColor]]];
    self.facebookSignup = NO;
}

#pragma mark - Login

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [User logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            if (error != nil) {
                NSLog(@"Error logging in user: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController sendFormattedErrorWithTitle:@"Login Error" message:@"An error occurred while logging into your account." error:error.localizedDescription];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            } else {
                NSLog(@"Successfully logged in user!");
                [strongSelf performSegueWithIdentifier:kLoginSegueIdentifier sender:nil];
            }
        }
    }];
}

- (IBAction)didTapLoginWithFacebook:(id)sender {
    NSArray *permissions = @[@"email", @"public_profile"];
    __weak typeof(self) weakSelf = self;
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (error != nil) {
                NSLog(@"Error logging in with Facebook: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController sendFormattedErrorWithTitle:@"Login Error" message:@"An error occurred while logging into your account." error:error.localizedDescription];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            } else if (!user) {
                NSLog(@"User cancelled Facebook login");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in with Facebook!");
                strongSelf.facebookSignup = YES;
                [strongSelf performSelector:@selector(transitionToSignup) withObject:nil afterDelay:0.5];
            } else {
                NSLog(@"User successfully logged in with Facebook!");
                [strongSelf performSegueWithIdentifier:kLoginSegueIdentifier sender:nil];
            }
        }
    }];
}

#pragma mark - Navigation

- (void)transitionToSignup {
    SignupViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(SignupViewController.class)];
    newView.signingUpWithFacebook = YES;
    [self performSegueWithIdentifier:kLoginSegueIdentifier sender:nil];
}

@end
