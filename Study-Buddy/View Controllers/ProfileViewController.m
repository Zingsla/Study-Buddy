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
@property (weak, nonatomic) IBOutlet UIButton *editImageButton;
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
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    [self loadImage];
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
        self.editImageButton.hidden = NO;
        self.inEditMode = YES;
    } else {
        user.firstName = self.firstNameField.text;
        user.lastName = self.lastNameField.text;
        user.year = [NSNumber numberWithInteger:(self.yearControl.selectedSegmentIndex + 1)];
        user.major = self.majorField.text;
        user.email = self.emailAddressField.text;
        user.emailAddress = self.emailAddressField.text;
        user.profileImage = [User getPFFileObjectFromImage:self.profileImage.image];
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
                self.editImageButton.hidden = YES;
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

- (void)loadImage {
    User *user = [User currentUser];
    if (user.profileImage != nil) {
        self.profileImage.file = user.profileImage;
        [self.profileImage loadInBackground];
    }
}

- (IBAction)didTapEditImage:(id)sender {
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = [self resizeImage:info[UIImagePickerControllerEditedImage] withSize:CGSizeMake(512, 512)];
    self.profileImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
