//
//  Scale.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "Scale.h"

@implementation Scale
{UILabel *graphName;
    
    BOOL isGraphValidDimensions;
    
    CGRect mainRect;
    
    CGFloat WIDTH;
    CGFloat HEIGHT;
    
    UIScrollView *scrollView;
    
    UIColor *backColor;
    UIColor *progressColor;
    
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
    backColor = [UIColor colorWithRed:245.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    progressColor = [UIColor colorWithRed:192.0/255.0 green:48.0/255.0 blue:54.0/255.0 alpha:1];
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

-(UIBezierPath*)setPathStartPoint:(CGPoint)startPoint andEndpoint:(CGPoint)endPoint
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}

-(MyShapeLayer*)shapeLayerWithpath:(CGPathRef)path lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)color
{
    MyShapeLayer *shapeLayer = [MyShapeLayer layer];
    shapeLayer.path = path;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = lineWidth;
    return shapeLayer;
}

-(void)intervalLinesWithValuesSingleValueDistance:(CGFloat)singleValueDistance singleIntervalDistance:(CGFloat)singleIntervalDistance largeIntervalDistance:(CGFloat)largeIntervalDistance maxValue:(CGFloat)maxValue scaleType:(NSInteger)scaleType
{
    
    for(int i=0;i<31;i++)
    {
        CGFloat intervalWidth = 5;
        UIBezierPath *layerPath;
        if(i%3==0)
        {
            intervalWidth = 15;
        }
        
        if(scaleType == VERTICAL)
        {
            layerPath = [self setPathStartPoint:CGPointMake((WIDTH/2)+(35/2), HEIGHT-BOTTOM_PADDING- (singleIntervalDistance * i)) andEndpoint:CGPointMake((WIDTH/2)+(35/2)+intervalWidth, HEIGHT-BOTTOM_PADDING- (singleIntervalDistance * i))];
        }
        else if(scaleType == HORIZONTAL)
        {
            layerPath = [self setPathStartPoint:CGPointMake(LEFT_PADDING+ (singleIntervalDistance * i),(HEIGHT/2)+(35/2)) andEndpoint:CGPointMake(LEFT_PADDING+ (singleIntervalDistance * i),(HEIGHT/2)+(35/2)+intervalWidth)];
        }
        
        [scrollViewUI.layer addSublayer:[self shapeLayerWithpath:layerPath.CGPath lineWidth:0.3 strokeColor:[UIColor blackColor]]];
        
    }
    
    for(int i=0;i<=10;i++)
    {
        CGRect lblFrame;
        if(scaleType == VERTICAL)
        {
            lblFrame= CGRectMake((WIDTH/2)+(35/2)+20, HEIGHT-BOTTOM_PADDING- (largeIntervalDistance * i)-(LABEL_HEIGHT/2), LABEL_WIDTH, LABEL_HEIGHT);
        }
        else
        {
            
            lblFrame= CGRectMake(LEFT_PADDING+ (largeIntervalDistance * i)-(LABEL_WIDTH/2), (HEIGHT/2)+(35/2)+20,LABEL_WIDTH, LABEL_HEIGHT);
        }
        
        
        UIFont *myFont = [UIFont boldSystemFontOfSize:10];
        UILabel *lblProgress = [[UILabel alloc] initWithFrame:lblFrame];
        lblProgress.tag =100;
        lblProgress.text =[NSString stringWithFormat:@"%d",(int)(maxValue/10) * i];
        lblProgress.font =  myFont;
        lblProgress.textColor =[UIColor blackColor];
        lblProgress.textAlignment = NSTextAlignmentCenter;
        [scrollViewUI addSubview:lblProgress];
        
    }
}

-(void)drawScaleMaxValue:(CGFloat)maxValue currentValue:(CGFloat)currentValue progressColor:(UIColor*)color scaleType:(NSInteger)scaleType isAnimationApply:(BOOL)isAnimate
{
    [self resetChart];
    
    if((int)maxValue%10!=0)
    {
        maxValue = maxValue+ (10-((int)maxValue%10));
    }
    
    MyShapeLayer *mainProgressLyer;
    UIBezierPath *progressLayerPath;
    UIBezierPath *backgroundLayerPath;
    
    CGFloat singleValueDistance;
    CGFloat largeIntervalDistance;
    CGFloat singleIntervalDistance;
    
    
    
    
    if(scaleType == VERTICAL)
    {
        singleValueDistance = (CGFloat)(HEIGHT-(BOTTOM_PADDING+TOP_PADDING))/maxValue;
        largeIntervalDistance = (CGFloat)(HEIGHT-(BOTTOM_PADDING+TOP_PADDING))/10;
        singleIntervalDistance = (CGFloat)(HEIGHT-(BOTTOM_PADDING+TOP_PADDING))/30;
        
        backgroundLayerPath = [self setPathStartPoint:CGPointMake(WIDTH/2, HEIGHT-BOTTOM_PADDING) andEndpoint:CGPointMake(WIDTH/2, TOP_PADDING)];
        
        
        mainProgressLyer = [self shapeLayerWithpath:[self setPathStartPoint:CGPointMake(WIDTH/2, HEIGHT-BOTTOM_PADDING) andEndpoint:CGPointMake(WIDTH/2, HEIGHT-BOTTOM_PADDING)].CGPath lineWidth:20 strokeColor:progressColor];
        
        
        
        progressLayerPath = [self setPathStartPoint:CGPointMake(WIDTH/2, HEIGHT-BOTTOM_PADDING) andEndpoint:CGPointMake(WIDTH/2, HEIGHT-BOTTOM_PADDING-(currentValue*singleValueDistance))];
        
        
        
        [scrollViewUI.layer addSublayer: [self createShapeLayerWithPath:[self createPathWithStartDegree:330 endDegree:390 pathCenter:CGPointMake((WIDTH/2)+(35/2)+17, HEIGHT-BOTTOM_PADDING-(currentValue*singleValueDistance)) andRadius:8] andColor:progressColor]];
    }
    else if(scaleType == HORIZONTAL)
    {
        
        
        singleValueDistance = (CGFloat)(WIDTH-(LEFT_PADDING+RIGHT_PADDING))/maxValue;
        largeIntervalDistance = (CGFloat)(WIDTH-(LEFT_PADDING+RIGHT_PADDING))/10;
        singleIntervalDistance = (CGFloat)(WIDTH-(LEFT_PADDING+RIGHT_PADDING))/30;
        
        backgroundLayerPath = [self setPathStartPoint:CGPointMake(LEFT_PADDING, HEIGHT/2) andEndpoint:CGPointMake(WIDTH-RIGHT_PADDING, HEIGHT/2)];
        
        mainProgressLyer = [self shapeLayerWithpath:[self setPathStartPoint:CGPointMake(LEFT_PADDING, HEIGHT/2) andEndpoint:CGPointMake(LEFT_PADDING, HEIGHT/2)].CGPath lineWidth:20 strokeColor:progressColor];
        
        
        progressLayerPath = [self setPathStartPoint:CGPointMake(LEFT_PADDING, HEIGHT/2) andEndpoint:CGPointMake(LEFT_PADDING+(currentValue*singleValueDistance),HEIGHT/2 )];
        
        //Progress Pointer
        [scrollViewUI.layer addSublayer: [self createShapeLayerWithPath:[self createPathWithStartDegree:60 endDegree:120 pathCenter:CGPointMake(LEFT_PADDING+(currentValue*singleValueDistance),(HEIGHT/2)+(35/2)+17) andRadius:8] andColor:progressColor]];
        
    }
    
    // Background Layer
    [scrollViewUI.layer addSublayer:[self shapeLayerWithpath:backgroundLayerPath.CGPath lineWidth:35 strokeColor:backColor]];
    
    [self intervalLinesWithValuesSingleValueDistance:singleValueDistance singleIntervalDistance:singleIntervalDistance largeIntervalDistance:largeIntervalDistance maxValue:maxValue scaleType:scaleType];
    
    if(isAnimate)
    {
        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnim.toValue = (id)progressLayerPath.CGPath;
        CAAnimationGroup *anims = [CAAnimationGroup animation];
        anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
        anims.removedOnCompletion = NO;
        anims.duration = 0.5f;
        anims.fillMode  = kCAFillModeForwards;
        [mainProgressLyer addAnimation:anims forKey:nil];
    }
    else
    {
        mainProgressLyer.path = progressLayerPath.CGPath;
    }
    
    [scrollViewUI.layer addSublayer:mainProgressLyer];
    
    
}

-(UIBezierPath*)createPathWithStartDegree:(CGFloat)startDegree endDegree:(CGFloat)endDegree pathCenter:(CGPoint)center andRadius:(CGFloat)radius
{
    
    UIBezierPath *newpath = [UIBezierPath bezierPath];
    [newpath moveToPoint:center];
    
    [newpath addArcWithCenter:center radius:radius startAngle:degreesToRadians(startDegree) endAngle:degreesToRadians(endDegree) clockwise:YES];
    return newpath;
}

-(MyShapeLayer*)createShapeLayerWithPath:(UIBezierPath*)path andColor:(UIColor*)color
{
    MyShapeLayer *shapeLayer = [MyShapeLayer layer];
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.path = [path CGPath];
    return shapeLayer;
}
@end
