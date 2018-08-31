//
//  Scale.h
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShapeLayer.h"

#define LEFT_PADDING 25
#define RIGHT_PADDING 25
#define TOP_PADDING 25
#define BOTTOM_PADDING 25
#define VERTICAL 0
#define HORIZONTAL 1
#define DEFAULT_LINE_WIDTH 1.0
#define LABEL_WIDTH 30
#define LABEL_HEIGHT 30
#define BAR_LINE_WIDTH 10
#define XYVALUE_FONT_SIZE 8
#define X_VALUE_KEY @"xValue"
#define Y_VALUE_KEY @"yValue"
#define degreesToRadians(x) ((x) * M_PI / 180.0)
#define COLOR_KEY @"color"
@interface Scale : UIView
-(void)drawScaleMaxValue:(CGFloat)maxValue currentValue:(CGFloat)currentValue progressColor:(UIColor*)color scaleType:(NSInteger)type isAnimationApply:(BOOL)isAnimate;
@end
