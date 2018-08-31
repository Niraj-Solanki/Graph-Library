//
//  PieChart3DController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 17/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "PieChart3DController.h"
#import "Pie3DChart.h"
@interface PieChart3DController ()
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;
@property (strong, nonatomic) IBOutlet Pie3DChart *pie3DChart;

@end

@implementation PieChart3DController
{
    
    NSDictionary *barValues;
    NSMutableArray *barValueArrray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    barValueArrray = [NSMutableArray array];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Book",@"data",
                @"11",@"xValue",
                [UIColor redColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"iPhone",@"data",
                @"27",@"xValue",
                [UIColor greenColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Laptop",@"data",
                @"22",@"xValue",
                [UIColor purpleColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
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
    [_pie3DChart drawPie3DChartWithValues:barValueArrray];
}

@end
