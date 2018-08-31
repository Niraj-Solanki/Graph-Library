//
//  DonutChartController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "DonutChartController.h"
#import "DonutChart.h"
@interface DonutChartController ()
@property (strong, nonatomic) IBOutlet DonutChart *donutChart;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;

@end

@implementation DonutChartController
{
NSDictionary *barValues;
NSMutableArray *barValueArrray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    barValueArrray = [NSMutableArray array];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Book",@"data",
                @"12",@"xValue",
                [UIColor redColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"iPhone",@"data",
                @"27",@"xValue",
                [UIColor magentaColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Laptop",@"data",
                @"45",@"xValue",
                [UIColor purpleColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Bags",@"data",
                @"31",@"xValue",
                [UIColor orangeColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
}


- (IBAction)updateGraphOnTap:(id)sender {
          [self.view endEditing:YES];
    [_donutChart drawDonutChartWithValues:barValueArrray];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addValueOnTap:(id)sender {
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                _yValue.text,@"data",
                _xValue.text,@"xValue",
                [UIColor orangeColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    _yValue.text = @"";
    _xValue.text =@"";
}


@end
