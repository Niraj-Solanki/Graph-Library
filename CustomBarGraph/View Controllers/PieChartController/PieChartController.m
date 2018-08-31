//
//  PieChartController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 17/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "PieChartController.h"
#import "GraphCommon.h"
@interface PieChartController ()
@property (strong, nonatomic) IBOutlet PieChart *pieChart;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;

@end

@implementation PieChartController
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
                [UIColor magentaColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Laptop",@"data",
                @"17",@"xValue",
                [UIColor purpleColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"Bags",@"data",
                @"31",@"xValue",
                [UIColor orangeColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
//    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
//                @"Laptop",@"data",
//                @"90",@"xValue",
//                nil];
//    [barValueArrray addObject:barValues];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateGraphOnTap:(id)sender {
      [self.view endEditing:YES];
    
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                _yValue.text,@"data",
                _xValue.text,@"xValue",
                [UIColor orangeColor],@"color",
                nil];
    [barValueArrray addObject:barValues];
    [_pieChart drawPieChartWithValues:barValueArrray];
    _xValue.text = @"";
    _yValue.text=@"";
    
}
- (IBAction)addValueOnTap:(id)sender {
}
- (IBAction)backOnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
