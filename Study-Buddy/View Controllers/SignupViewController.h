//
//  SignupViewController.h
//  Study-Buddy
//
//  Created by Jacob Franz on 7/13/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignupViewController : UIViewController

@property (assign, nonatomic) BOOL signingUpWithFacebook;
extern NSString *const kSignupSegueIdentifier;
extern CGFloat const kProfilePhotoBorderSize;

- (BOOL)allFieldsFilled;

@end

NS_ASSUME_NONNULL_END
