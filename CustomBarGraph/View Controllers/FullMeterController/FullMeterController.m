//
//  FullMeterController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "FullMeterController.h"
#import "FullMeter.h"

@interface FullMeterController ()
@property (strong, nonatomic) IBOutlet FullMeter *fullMeter;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;

@end

@implementation FullMeterController
{

    BOOL isWhiteColorBackground;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isWhiteColorBackground = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backOnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addValueOnTap:(id)sender {
}
- (IBAction)updateGraphOnTap:(id)sender {
          [self.view endEditing:YES];
    [_fullMeter drawFullMeterChartWithValues:40 currentValue:2 intervals:4 andMeterColor:isWhiteColorBackground];
    
}
- (IBAction)intervalSwitchOnToggle:(id)sender {
    
}
- (IBAction)whiteColorSwitchOnToggle:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        isWhiteColorBackground = YES;
    } else {
        isWhiteColorBackground = NO;
    }
}

@end
