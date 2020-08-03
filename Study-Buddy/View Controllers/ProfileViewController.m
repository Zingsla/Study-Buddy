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
#import "SignupViewController.h"
#import "User.h"
#import <MBProgressHUD/MBProgressHUD.h>
@import Parse;

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearControl;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UILabel *editImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkedLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *unlinkButton;
@property (assign, nonatomic) BOOL inEditMode;

@end

@implementation ProfileViewController

CGFloat const kAnimationDuration = 0.25;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    self.nameLabel.text = [user getNameString];
    self.yearLabel.text = [user getYearString];
    self.majorLabel.text = user.major;
    self.emailLabel.text = user.email;
    [self checkLink];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    [self.profileImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.profileImage.layer setBorderWidth:kProfilePhotoBorderSize];
    [self loadImage];
    self.inEditMode = NO;
}

#pragma mark - Logout

- (IBAction)didTapLogout:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error logging out: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully logged out!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                SceneDelegate *myDelegate = (SceneDelegate *)strongSelf.view.window.windowScene.delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(LoginViewController.class)];
                myDelegate.window.rootViewController = loginViewController;
            }
        }
    }];
}

#pragma mark - Profile Edit

- (IBAction)didTapEdit:(id)sender {
    User *user = [User currentUser];
    
    if (!self.inEditMode) {
        self.firstNameField.text = user.firstName;
        self.lastNameField.text = user.lastName;
        self.yearControl.selectedSegmentIndex = user.year.intValue - 1;
        self.majorField.text = user.major;
        self.emailAddressField.text = user.email;
        self.editButton.title = @"Save Changes";
        self.inEditMode = YES;
        [self checkLink];
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.nameLabel.alpha = 0;
            self.yearLabel.alpha = 0;
            self.majorLabel.alpha = 0;
            self.emailLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.firstNameField.alpha = 1;
                self.lastNameField.alpha = 1;
                self.yearControl.alpha = 1;
                self.majorField.alpha = 1;
                self.emailAddressField.alpha = 1;
                self.editImageLabel.alpha = 1;
            }];
        }];
    } else {
        user.firstName = self.firstNameField.text;
        user.lastName = self.lastNameField.text;
        user.year = [NSNumber numberWithInteger:(self.yearControl.selectedSegmentIndex + 1)];
        user.major = self.majorField.text;
        user.email = self.emailAddressField.text;
        user.emailAddress = self.emailAddressField.text;
        user.profileImage = [User getPFFileObjectFromImage:self.profileImage.image];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error saving user changes: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully saved user changes!");
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    strongSelf.nameLabel.text = [user getNameString];
                    strongSelf.yearLabel.text = [user getYearString];
                    strongSelf.majorLabel.text = user.major;
                    strongSelf.emailLabel.text = user.email;
                    strongSelf.editButton.title = @"Edit";
                    strongSelf.inEditMode = NO;
                    [strongSelf checkLink];
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        strongSelf.firstNameField.alpha = 0;
                        strongSelf.lastNameField.alpha = 0;
                        strongSelf.yearControl.alpha = 0;
                        strongSelf.majorField.alpha = 0;
                        strongSelf.emailAddressField.alpha = 0;
                        strongSelf.editImageLabel.alpha = 0;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:kAnimationDuration animations:^{
                            strongSelf.nameLabel.alpha = 1;
                            strongSelf.yearLabel.alpha = 1;
                            strongSelf.majorLabel.alpha = 1;
                            strongSelf.emailLabel.alpha = 1;
                        }];
                    }];
                }
            }
        }];
    }
}

#pragma mark - Facebook Link

- (void)checkLink {
    if ([User currentUser].facebookAccount) {
        self.linkedLabel.text = @"Account created with Facebook";
        if (self.inEditMode) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.unlinkButton.alpha = 0;
                self.linkButton.alpha = 0;
                self.linkedLabel.alpha = 0;
            }];
        } else {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.unlinkButton.alpha = 0;
                self.linkButton.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.linkedLabel.alpha = 1;
                }];
            }];
        }
    } else if ([PFFacebookUtils isLinkedWithUser:[User currentUser]]) {
        self.linkedLabel.text = @"Account linked with Facebook";
        if (self.inEditMode) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.linkButton.alpha = 0;
                self.linkedLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.unlinkButton.alpha = 1;
                }];
            }];
        } else {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.linkButton.alpha = 0;
                self.unlinkButton.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.linkedLabel.alpha = 1;
                }];
            }];
        }
    } else {
        self.linkedLabel.text = @"Account not linked with Facebook";
        if (self.inEditMode) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.unlinkButton.alpha = 0;
                self.linkedLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.linkButton.alpha = 1;
                }];
            }];
        } else {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.unlinkButton.alpha = 0;
                self.linkButton.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    self.linkedLabel.alpha = 1;
                }];
            }];
        }
    }
}

- (IBAction)didTapLink:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [PFFacebookUtils linkUserInBackground:[User currentUser] withReadPermissions:nil block:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error linking Faceboook account: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully linked Facebook account!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [strongSelf checkLink];
            }
        }
    }];
}

- (IBAction)didTapUnlink:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [PFFacebookUtils unlinkUserInBackground:[User currentUser] block:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Eror unlinking Facebook account: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully unlinked Facebook account!");
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [strongSelf checkLink];
            }
        }
    }];
}

#pragma mark - Photo Selection

- (void)loadImage {
    User *user = [User currentUser];
    if (user.profileImage != nil) {
        self.profileImage.file = user.profileImage;
        [self.profileImage loadInBackground];
    }
}

- (IBAction)didTapEditImage:(id)sender {
    if (self.inEditMode) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showPhotoMenu];
        } else {
            [self selectPhotoFromLibrary];
        }
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
    self.profileImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
