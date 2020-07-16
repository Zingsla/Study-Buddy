//
//  BlockoutDetailsViewController.m
//  Study-Buddy
//
//  Created by Jacob Franz on 7/16/20.
//  Copyright © 2020 Jacob Franz. All rights reserved.
//

#import "BlockoutDetailsViewController.h"

@interface BlockoutDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation BlockoutDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self colorLabels];
    self.startTimeLabel.text = [self.timeBlock getStartTimeString];
    self.endTimeLabel.text = [self.timeBlock getEndTimeString];
}

- (void)colorLabels {
    if (self.timeBlock.monday) {
        self.mondayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.mondayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
    if (self.timeBlock.tuesday) {
        self.tuesdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.tuesdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
    if (self.timeBlock.wednesday) {
        self.wednesdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.wednesdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
    if (self.timeBlock.thursday) {
        self.thursdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.thursdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
    if (self.timeBlock.friday) {
        self.fridayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.fridayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
    if (self.timeBlock.saturday) {
        self.saturdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.saturdayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
    if (self.timeBlock.sunday) {
        self.sundayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    } else {
        self.sundayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight];
    }
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
