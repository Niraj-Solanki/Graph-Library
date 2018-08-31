//
//  HalfMeterController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "HalfMeterController.h"
#import "HalfMeter.h"

@interface HalfMeterController ()
@property (strong, nonatomic) IBOutlet HalfMeter *halfMeter;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;
@property (strong, nonatomic) IBOutlet UISwitch *graphSwitchType;

@end

@implementation HalfMeterController
{
    BOOL isGraphHalf;
    BOOL isAnimate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isGraphHalf = NO;
    isAnimate = NO;
    // Do any additional setup after loading the view.
}
- (IBAction)onSwitchToggle:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        isGraphHalf = YES;
    } else {
        isGraphHalf = NO;
    }
}
- (IBAction)animationSwitchToggle:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        isAnimate = YES;
    } else {
        isAnimate = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backOnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)udpateGraphOnTap:(id)sender {
          [self.view endEditing:YES];
    [_halfMeter drawHalfMeterChartWithValues:[_xValue.text integerValue] andCurrentValue:[_yValue.text integerValue] andColor:[UIColor redColor] isGraphType:isGraphHalf isAnimationApply:isAnimate];
}


@end
