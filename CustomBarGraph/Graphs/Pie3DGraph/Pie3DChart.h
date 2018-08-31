//
//  PieChart.h
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 17/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellForPieChart.h"
#import "MyShapeLayer.h"

#define LEFT_PADDING 35
#define RIGHT_PADDING 30
#define TOP_PADDING 20
#define BOTTOM_PADDING 50
#define DEFAULT_LINE_WIDTH 1.0
#define LABEL_WIDTH 25
#define LABEL_HEIGHT 15
#define BAR_LINE_WIDTH 10
#define XYVALUE_FONT_SIZE 8
#define X_VALUE_KEY @"xValue"
#define Y_VALUE_KEY @"yValue"
#define degreesToRadians(x) ((x) * M_PI / 180.0)
#define COLOR_KEY @"color"
@interface Pie3DChart : UIView <UITableViewDelegate,UITableViewDataSource>
-(void)drawPie3DChartWithValues:(NSArray*)values;
@end
