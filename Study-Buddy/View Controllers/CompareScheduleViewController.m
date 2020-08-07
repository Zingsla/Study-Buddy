//
//  CompareScheduleViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CompareScheduleViewController.h"
#import "ComparePageContentViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface CompareScheduleViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *dayNames;
@property (strong, nonatomic) NSArray *freetimeArrays;

@end

@implementation CompareScheduleViewController

NSString *const kPageViewControllerIdentifier = @"PageViewController";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.dayNames = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
    self.freetimeArrays = [[User currentUser] compareScheduleWith:self.user];

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:kPageViewControllerIdentifier];
    self.pageViewController.dataSource = self;
    
    ComparePageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((ComparePageContentViewController *) viewController).pageIndex;
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((ComparePageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == self.dayNames.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (ComparePageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (self.dayNames.count == 0 || index >= self.dayNames.count) {
        return nil;
    }
    
    ComparePageContentViewController *comparePageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(ComparePageContentViewController.class)];
    comparePageContentViewController.dayText = self.dayNames[index];
    comparePageContentViewController.freeTimes = self.freetimeArrays[index];
    comparePageContentViewController.pageIndex = index;
    return comparePageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.dayNames.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
