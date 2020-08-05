//
//  SignupViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "SignupViewController.h"
#import "ProfileViewController.h"
#import "UIAlertController+Utils.h"
#import "User.h"
#import <ChameleonFramework/Chameleon.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>

static NSString *const errorTitle = @"Signup Error";

@interface SignupViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearControl;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *existingAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *existingAccountButton;

@end

@implementation SignupViewController

NSString *const kSignupSegueIdentifier = @"SignupSegue";
CGFloat const kProfilePhotoBorderSize = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame andColors:@[[UIColor flatGreenColor], [UIColor flatMintColor]]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    [self.profileImageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.profileImageView.layer setBorderWidth:kProfilePhotoBorderSize];
    if (self.signingUpWithFacebook) {
        FBSDKProfile *profile = [FBSDKProfile currentProfile];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/", profile.userID] parameters:@{@"fields": @"email"} HTTPMethod:@"GET"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection * _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                if (error != nil) {
                    NSLog(@"Error fetching Facebook user data: %@", error.localizedDescription);
                    UIAlertController *alert = [UIAlertController sendErrorWithTitle:errorTitle message:@"An error occurred while fetching your Facebook data. Please try again."];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                } else {
                    NSLog(@"Successfully fetched Facebook user data!");
                    strongSelf.firstNameField.text = profile.firstName;
                    strongSelf.lastNameField.text = profile.lastName;
                    strongSelf.emailField.text = result[@"email"];
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        strongSelf.existingAccountLabel.alpha = 0;
                        strongSelf.existingAccountButton.alpha = 0;
                        strongSelf.usernameField.alpha = 0;
                        strongSelf.passwordField.alpha = 0;
                    }];
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", profile.userID]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    strongSelf.profileImageView.image = [User resizeImage:[UIImage imageWithData:data] withSize:CGSizeMake(kDefaultProfilePhotoSize, kDefaultProfilePhotoSize)];
                }
            }
        }];
    }
}

#pragma mark - Signup

- (IBAction)didTapSignup:(id)sender {
    if (self.signingUpWithFacebook) {
        User *user = [User currentUser];
        user.email = self.emailField.text;
        user.emailAddress = self.emailField.text;
        user.firstName = self.firstNameField.text;
        user.lastName = self.lastNameField.text;
        user.major = self.majorField.text;
        user.year = [NSNumber numberWithInteger:(self.yearControl.selectedSegmentIndex + 1)];
        user.schedule = [[NSMutableArray alloc] init];
        user.profileImage = [User getPFFileObjectFromImage:self.profileImageView.image];
        user.facebookAccount = YES;
        
        if ([self allFieldsFilled]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak typeof(self) weakSelf = self;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    if (error != nil) {
                        NSLog(@"Error saving Facebook user: %@", error.localizedDescription);
                        UIAlertController *alert = [UIAlertController sendFormattedErrorWithTitle:errorTitle message:@"An error occurred while signing up your account." error:error.localizedDescription];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    } else {
                        NSLog(@"Successfully saved Facebook user!");
                        [strongSelf performSegueWithIdentifier:kSignupSegueIdentifier sender:nil];
                    }
                }
            }];
        } else {
            UIAlertController *alert = [UIAlertController sendErrorWithTitle:errorTitle message:@"At least one field has not been filled in. Please fill in all fields and try again."];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
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
        newUser.profileImage = [User getPFFileObjectFromImage:self.profileImageView.image];
        newUser.facebookAccount = NO;
        
        if ([self allFieldsFilled]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak typeof(self) weakSelf = self;
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    if (error != nil) {
                        NSLog(@"Error signing up user: %@", error.localizedDescription);
                        UIAlertController *alert = [UIAlertController sendFormattedErrorWithTitle:errorTitle message:@"An error occurred while signing up your account." error:error.localizedDescription];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    } else {
                        NSLog(@"Successfully signed up new user!");
                        [strongSelf performSegueWithIdentifier:kSignupSegueIdentifier sender:nil];
                    }
                }
            }];
        } else {
            UIAlertController *alert = [UIAlertController sendErrorWithTitle:errorTitle message:@"At least one field has not been filled in. Please fill in all fields and try again."];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Helper Methods

- (BOOL)allFieldsFilled {
    if (self.signingUpWithFacebook) {
        return (![self.emailField.text isEqualToString:@""] && ![self.firstNameField.text isEqualToString:@""] && ![self.lastNameField.text isEqualToString:@""] && ![self.majorField.text isEqualToString:@""]);
    } else {
        return (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.firstNameField.text isEqualToString:@""] && ![self.lastNameField.text isEqualToString:@""] && ![self.majorField.text isEqualToString:@""]);
    }
}

#pragma mark - Photo Selection

- (IBAction)didTapProfileImage:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showPhotoMenu];
    } else {
        [self selectPhotoFromLibrary];
    }
}

- (void)showPhotoMenu {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithCamera];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromLibrary];
    }];
    [alert addAction:cancelAction];
    [alert addAction:cameraAction];
    [alert addAction:libraryAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)takePhotoWithCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)selectPhotoFromLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = [User resizeImage:info[UIImagePickerControllerEditedImage] withSize:CGSizeMake(kDefaultProfilePhotoSize, kDefaultProfilePhotoSize)];
    self.profileImageView.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
