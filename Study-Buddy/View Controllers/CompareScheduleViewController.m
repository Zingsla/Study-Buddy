//
//  CompareScheduleViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/23/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "CompareScheduleViewController.h"
#import "ComparePageContentViewController.h"

@interface CompareScheduleViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *dayNames;
@property (strong, nonatomic) NSArray *freetimeArrays;

@end

@implementation CompareScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayNames = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
    [self findFreetimes];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    ComparePageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)findFreetimes {
    self.freetimeArrays = @[@[], @[], @[], @[], @[], @[], @[]];
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
    
    ComparePageContentViewController *comparePageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
