//
//  FullMeter.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "FullMeter.h"

@implementation FullMeter
{
    UILabel *graphName;
    
    BOOL isGraphValidDimensions;
    
    CGRect mainRect;
    
    CGFloat WIDTH;
    CGFloat HEIGHT;
    
    UIScrollView *scrollView;
    
    UIView *scrollViewUI;
    
}

-(void)drawRect:(CGRect)rect
{
    
    WIDTH = 300;
    HEIGHT = 300;
    
    if(300<rect.size.height)
    {
        HEIGHT = self.frame.size.height;
    }
    if (300 <rect.size.width )
    {
        WIDTH = self.frame.size.width;
    }
    mainRect = rect;
    
    scrollViewUI.multipleTouchEnabled =YES;
}

-(void)resetChart
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.layer.sublayers =nil;
    [self setUpScrollViewWithInnerView:mainRect];
    
}


-(void)setUpScrollViewWithInnerView:(CGRect)frame
{
    
    scrollView =[[UIScrollView alloc] initWithFrame:frame];
    scrollViewUI.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    
    scrollViewUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    [scrollView addSubview:scrollViewUI];
    scrollView.bounces =NO;
    scrollView.contentSize = scrollViewUI.frame.size;
    
}


-(void)drawFullMeterChartWithValues:(NSInteger)maxValue currentValue:(NSInteger)currentvalue intervals:(NSInteger)intervals andMeterColor:(BOOL)isWhiteColorBackground
{
    [self resetChart];
    
    
    

    CGPoint center = CGPointMake(WIDTH/2, HEIGHT/2);
    CGFloat radius = center.x -50;
    
    UIColor *green=[UIColor colorWithRed:90.0/255.0 green:161.0/255.0 blue:58.0/255.0 alpha:1];
    UIColor *yellow=[UIColor colorWithRed:245.0/255.0
                                        green:196.0/255.0
                                         blue:38.0/255.0
                                        alpha:1];
    UIColor *orange=[UIColor colorWithRed:236.0/255.0 green:116.0/255.0 blue:37.0/255.0 alpha:1];
    UIColor *red=[UIColor colorWithRed:195.0/255.0
                                    green:49.0/255.0
                                     blue:43.0/255.0
                                    alpha:1];
    
    NSArray *colorCode = [NSArray arrayWithObjects:green,yellow,orange,red, nil];
     UIColor *backLayer=[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    // background Layer
    if(isWhiteColorBackground)
    {
        
        [scrollViewUI.layer addSublayer:[self createShapeLayerWithPath:[self createPathWithStartDegree:0 endDegree:360 pathCenter:center andRadius:radius+1] andColor:backLayer]];
        backLayer = [UIColor whiteColor];
    }
   
     [scrollViewUI.layer addSublayer:[self createShapeLayerWithPath:[self createPathWithStartDegree:0 endDegree:360 pathCenter:center andRadius:radius] andColor:backLayer]];
   
    CGFloat endDegree = (220/intervals);
    CGFloat intervalDistance = endDegree/4;
    CGFloat startDegree = 160;
    
    for(int i = 0; i < 4;i++)
    {
        
        
    [scrollViewUI.layer addSublayer:[self createShapeLayerWithPath:[self createPathWithStartDegree:startDegree endDegree:startDegree+endDegree pathCenter:center andRadius:radius-5] andColor:[colorCode objectAtIndex:i]]];
    
        startDegree = startDegree + endDegree;
    }
    
    CGPoint newCentre = center;
    newCentre.x = newCentre.x-7;
    newCentre.y = newCentre.y+4;
        [scrollViewUI.layer addSublayer:[self createShapeLayerWithPath:[self createPathWithStartDegree:0 endDegree:360 pathCenter:newCentre andRadius:radius-15] andColor:backLayer]];
    
    
    
    startDegree = 160;
    CGFloat radiusIndentation = (CGFloat)7/16;
    CGFloat leftRadiusIndentation = (CGFloat)12/16;
    for(int i = 1; i <= 4;i++)
    {
        
        for(int j=1;j<=4;j++)
        {
            CGFloat newRadius = 15;
            CGRect shapePoints;
            radiusIndentation = radiusIndentation + (CGFloat)7/16;
            leftRadiusIndentation = leftRadiusIndentation + (CGFloat)14/16;
            if(j%2==1)
            {
           shapePoints =  [self createPathWithStartDegree:startDegree+(intervalDistance*j) endDegree:startDegree+(intervalDistance*j) pathCenter:center andRadius:(radius-13)-radiusIndentation-leftRadiusIndentation].bounds;
            NSLog(@"max X: %f max Y: %f",CGRectGetMinX(shapePoints),CGRectGetMinY(shapePoints));
                newRadius =5;
            }
            else
            {
                shapePoints =  [self createPathWithStartDegree:startDegree+(intervalDistance*j) endDegree:startDegree+(intervalDistance*j) pathCenter:center andRadius:(radius-22)-radiusIndentation-leftRadiusIndentation].bounds;
                NSLog(@"max X: %f max Y: %f",CGRectGetMinX(shapePoints),CGRectGetMinY(shapePoints));
                newRadius =15;
            }

            CGPoint newCenterPoint= center;
            if(startDegree+(intervalDistance*j) >= 90 && 180 > startDegree+(intervalDistance*j))
            {
                newCenterPoint.x =  CGRectGetMinX(shapePoints);
                newCenterPoint.y =  CGRectGetMaxY(shapePoints);
                            
                            }
            else if(startDegree+(intervalDistance*j) >= 180 && 270 > startDegree+(intervalDistance*j))
            {
                newCenterPoint.x =  CGRectGetMinX(shapePoints);
                newCenterPoint.y =  CGRectGetMinY(shapePoints);
            }
            else if(startDegree+(intervalDistance*j) >= 270 && 360 > startDegree+(intervalDistance*j))
            {
                newCenterPoint.x =  CGRectGetMaxX(shapePoints);
                newCenterPoint.y =  CGRectGetMinY(shapePoints);
            }
            else
            {
                newCenterPoint.x =  CGRectGetMaxX(shapePoints);
                newCenterPoint.y =  CGRectGetMaxY(shapePoints);
            }
            
            MyShapeLayer *shapeLayer = [MyShapeLayer layer];
            shapeLayer.path = [self createPathWithStartDegree:startDegree+(intervalDistance*j) endDegree:startDegree+(intervalDistance*j) pathCenter:newCenterPoint andRadius:newRadius].CGPath;
            
            shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            [scrollViewUI.layer addSublayer:shapeLayer];
            

            
            
        }
        startDegree = startDegree + endDegree;
    }
    
    
    
    UIFont *myFont = [UIFont boldSystemFontOfSize:17];
    UILabel *lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(center.x-40,center.y+(radius/3), 80, 22)];
    lblProgress.tag =100;
    lblProgress.text =[NSString stringWithFormat:@"%d%%",(int)currentvalue];
    
    lblProgress.font =  myFont;
    lblProgress.textColor =[UIColor blackColor];
    lblProgress.textAlignment = NSTextAlignmentCenter;
    [scrollViewUI addSubview:lblProgress];
    

}


-(void)displayData:(NSInteger)data
{
    
    UIFont *myFont = [UIFont boldSystemFontOfSize:15];
    UILabel *lblProgress = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH/2)-40,(HEIGHT/2)+5, 80, 22)];
    lblProgress.tag =100;
    lblProgress.text =[NSString stringWithFormat:@"%d%%",(int)data];
    
    lblProgress.font =  myFont;
    lblProgress.textColor =[UIColor blackColor];
    lblProgress.textAlignment = NSTextAlignmentCenter;
    [scrollViewUI addSubview:lblProgress];
}

-(MyShapeLayer*)createShapeLayerWithPath:(UIBezierPath*)path andColor:(UIColor*)color
{
    MyShapeLayer *shapeLayer = [MyShapeLayer layer];
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.path = [path CGPath];
    return shapeLayer;
}

-(UIBezierPath*)createPathWithStartDegree:(CGFloat)startDegree endDegree:(CGFloat)endDegree pathCenter:(CGPoint)center andRadius:(CGFloat)radius
{
    
    UIBezierPath *newpath = [UIBezierPath bezierPath];
    [newpath moveToPoint:center];
    
    [newpath addArcWithCenter:center radius:radius startAngle:degreesToRadians(startDegree) endAngle:degreesToRadians(endDegree) clockwise:YES];
    return newpath;
}

@end
