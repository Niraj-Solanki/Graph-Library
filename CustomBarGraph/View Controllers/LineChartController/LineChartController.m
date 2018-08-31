//
//  LineChartController.m
//  CustomlineGraph
//
//  Created by Neeraj Solanki on 17/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "LineChartController.h"
#import "GraphCommon.h"
@interface LineChartController () 
@property (strong, nonatomic) IBOutlet LineGraph *lineGraph;
@property (strong, nonatomic) IBOutlet UITextField *xValue;
@property (strong, nonatomic) IBOutlet UITextField *yValue;

@end

@implementation LineChartController
{
NSDictionary *lineValues;
NSMutableArray *lineValueArrray;
NSInteger index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    index =0;
    lineValueArrray = [NSMutableArray array];
    lineValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"7",Y_VALUE_KEY,
                @"34",X_VALUE_KEY,
                [UIColor greenColor],COLOR_KEY,
                nil];
    [lineValueArrray addObject:lineValues];
    lineValues =[NSDictionary dictionaryWithObjectsAndKeys:
                @"40",Y_VALUE_KEY,
                @"102",X_VALUE_KEY,
                nil];
    
    [lineValueArrray addObject:lineValues];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateGraphOnTap:(id)sender {
    index++;
    [_lineGraph setUpLineGraph:self];
    [_lineGraph setGraphName:[NSString stringWithFormat:@"My Graph %d",(int)index]];
    [_lineGraph drawLineGraph:lineValueArrray];

}
- (IBAction)addValueOnTap:(id)sender {
    lineValues =[NSDictionary dictionaryWithObjectsAndKeys:
                _yValue.text,Y_VALUE_KEY,
                _xValue.text,X_VALUE_KEY,
                [UIColor blueColor],COLOR_KEY,
                nil];
    [lineValueArrray addObject:lineValues];
    _yValue.text = @"";
    _xValue.text =@"";
    
}

- (IBAction)backOnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
