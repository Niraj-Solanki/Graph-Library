//
//  VHScaleController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "VHScaleController.h"
#import "Scale.h"
@interface VHScaleController ()
@property (strong, nonatomic) IBOutlet Scale *scale;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;
@property (strong, nonatomic) IBOutlet UISwitch *scaleTypeSwitch;

@end

@implementation VHScaleController
{
    NSInteger graphType;
    BOOL isAnimate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    graphType = VERTICAL;
    isAnimate = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)animationSwithToggle:(id)sender {
    
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        isAnimate = YES;
    } else {
        isAnimate = NO;
    }
}
- (IBAction)scaleTypeSwitchOnToggle:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        graphType = HORIZONTAL;
    } else {
    graphType = VERTICAL;
    }
}


- (IBAction)backOnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)updateGraphOnTap:(id)sender {
          [self.view endEditing:YES];
    [_scale drawScaleMaxValue:[_xValue.text floatValue] currentValue:[_yValue.text floatValue] progressColor:[UIColor redColor] scaleType:graphType isAnimationApply:isAnimate];
}

@end
