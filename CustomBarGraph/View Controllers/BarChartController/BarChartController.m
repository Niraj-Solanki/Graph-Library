//
//  BarChartController.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 17/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "BarChartController.h"
#import "GraphCommon.h"
@interface BarChartController()
@property (strong, nonatomic) IBOutlet BarGraph *barChart;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;

@end

@implementation BarChartController
{
    NSDictionary *barValues;
    NSMutableArray *barValueArrray;
    NSInteger index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    index =0;
    barValueArrray = [NSMutableArray array];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"7",Y_VALUE_KEY,
                @"34",X_VALUE_KEY,
                [UIColor greenColor],COLOR_KEY,
                nil];
    [barValueArrray addObject:barValues];
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"40",Y_VALUE_KEY,
                @"102",X_VALUE_KEY,
                nil];
    
    [barValueArrray addObject:barValues];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addValueOnTap:(id)sender {
    barValues =[NSDictionary dictionaryWithObjectsAndKeys:
                _yValue.text,Y_VALUE_KEY,
                _xValue.text,X_VALUE_KEY,
                [UIColor blueColor],COLOR_KEY,
                nil];
    [barValueArrray addObject:barValues];
    _yValue.text = @"";
    _xValue.text =@"";
    
}
- (IBAction)updateGraphOnTap:(id)sender {
    index++;
    [_barChart setUpBarGraph:self];
    [_barChart setGraphName:[NSString stringWithFormat:@"My Graph %d",(int)index]];
    [_barChart drawBarGraph:barValueArrray];
 
}
- (IBAction)backOnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}






@end
