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

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    self.nameLabel.text = [user getNameString];
    self.yearLabel.text = [user getYearString];
    self.majorLabel.text = user.major;
    self.emailLabel.text = user.email;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
