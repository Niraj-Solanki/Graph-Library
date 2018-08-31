//
//  MyShapeLayer.h
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 12/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface MyShapeLayer : CAShapeLayer
@property (nonatomic) NSInteger tag;
@property (nonatomic) CGFloat xValue;
@property (nonatomic) CGFloat yValue;
@property (nonatomic) CGFloat xPoint;
@property (nonatomic) CGFloat yPoint;
@property (nonatomic) CGFloat layerWidth;
@property (nonatomic) UIColor *color;
@property (nonatomic) CGPoint startPoints;
@property (nonatomic) CGPoint endPoints;
@property (nonatomic) NSString* data;
@property (nonatomic) CGPathRef path11;

@property (nonatomic) UIBezierPath* transformablePath;
@property (nonatomic) double value;
@property (nonatomic) CGFloat startDegree;
@property (nonatomic) CGFloat endDegree;


@end
