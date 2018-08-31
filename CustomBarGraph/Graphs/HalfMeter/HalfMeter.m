//
//  HalfMeter.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "HalfMeter.h"

@implementation HalfMeter
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


-(void)drawHalfMeterChartWithValues:(NSInteger)maxValue andCurrentValue:(NSInteger)currentvalue andColor:(UIColor*)color isGraphType:(BOOL)isHalf isAnimationApply:(BOOL)isAnimate
{
    [self resetChart];
    if(maxValue%8!=0)
    {
        maxValue = maxValue+ (8-(maxValue%8));
    }
    
    CGFloat singleDegreeValue = (CGFloat)180 / (CGFloat)maxValue;
    CGPoint center = CGPointMake(WIDTH/2, HEIGHT/2);
    CGFloat radius = center.x -50;
    
    CGFloat endDegree = singleDegreeValue * currentvalue;
    UIColor *backLayer=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
    UIColor *frontLayer=[UIColor colorWithRed:150.0/255.0
                                        green:196.0/255.0
                                         blue:46.0/255.0
                                        alpha:1];
    
    if (!isHalf) {
        frontLayer=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        backLayer=[UIColor colorWithRed:150.0/255.0  green:196.0/255.0 blue:46.0/255.0  alpha:1];
        
        
    }
    // Back  Layer
    [scrollViewUI.layer addSublayer: [self createShapeLayerWithPath:[self createPathWithStartDegree:180
                                                                                          endDegree:360
                                                                                         pathCenter:center
                                                                                          andRadius:radius
                                                                     ]
                                                           andColor:backLayer]];
    
    
    CGRect lblFrame= CGRectMake(0, 0, LABEL_WIDTH, LABEL_HEIGHT);
    CGFloat degreeDistance = (CGFloat)180/8;
    CGFloat startDegree = 180;
    CGFloat DistanceValue = maxValue/8;
    

    
    
    for(int j =0;j<9;j++)
    {
        
        CGRect shapePoints =  [self createPathWithStartDegree:startDegree+(degreeDistance*j) endDegree:startDegree+(degreeDistance*j) pathCenter:center andRadius:radius].bounds;
        
      
         if(startDegree+(degreeDistance*j) == 90)
        {
            lblFrame.origin.x =  CGRectGetMaxX(shapePoints)-LABEL_WIDTH/2;
            lblFrame.origin.y =  CGRectGetMaxY(shapePoints);
            
        }
        else if(startDegree+(degreeDistance*j) == 270)
        {
            lblFrame.origin.x =  CGRectGetMaxX(shapePoints)-LABEL_WIDTH/2;
            lblFrame.origin.y =  CGRectGetMinY(shapePoints)-LABEL_HEIGHT;
            
        }
        else if(startDegree+(degreeDistance*j) >= 90 && 180 > startDegree+(degreeDistance*j))
        {
            lblFrame.origin.x =  CGRectGetMinX(shapePoints);
            lblFrame.origin.y =  CGRectGetMaxY(shapePoints);
            
        }
        else if(startDegree+(degreeDistance*j) >=180 && 270 > startDegree+(degreeDistance*j))
        {
            lblFrame.origin.x =  CGRectGetMinX(shapePoints)-LABEL_WIDTH;
            lblFrame.origin.y =  CGRectGetMinY(shapePoints)-LABEL_HEIGHT;
        }
        else if(startDegree+(degreeDistance*j) > 270 && 360 >= startDegree+(degreeDistance*j))
        {
            lblFrame.origin.x =  CGRectGetMaxX(shapePoints);
            lblFrame.origin.y =  CGRectGetMinY(shapePoints)-LABEL_HEIGHT;
        }
        else if(startDegree+(degreeDistance*j) >= 0 && 90 > startDegree+(degreeDistance*j))
        {
            lblFrame.origin.x =  CGRectGetMaxX(shapePoints);
            lblFrame.origin.y =  CGRectGetMaxY(shapePoints)-LABEL_HEIGHT;
        }

        UIFont *myFont = [UIFont boldSystemFontOfSize:8];
        UILabel *lblProgress = [[UILabel alloc] initWithFrame:lblFrame];
        lblProgress.tag =100;
        lblProgress.text =[NSString stringWithFormat:@"%d",(int)DistanceValue*j];
        lblProgress.font =  myFont;
        lblProgress.textColor =[UIColor blackColor];
        lblProgress.textAlignment = NSTextAlignmentCenter;
        [scrollViewUI addSubview:lblProgress];
    }
    
    
    
    
    
    
    // Front Layer
    MyShapeLayer *layer = [self createShapeLayerWithPath:[self createPathWithStartDegree:180
                                                                               endDegree:180
                                                                              pathCenter:center
                                                                               andRadius:radius
                                                          ]
                                                andColor:frontLayer];
    
    [scrollViewUI.layer addSublayer:layer];
    
    if(isHalf)
    {
        [scrollViewUI.layer addSublayer: [self createShapeLayerWithPath:[self createPathWithStartDegree:180
                                                                                              endDegree:360
                                                                                             pathCenter:center
                                                                                              andRadius:radius-20
                                                                         ]
                                                               andColor:[UIColor whiteColor]]];
    }
    
    
    
    
    
    if(isAnimate)
    {
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnim.toValue = (id)[self createPathWithStartDegree:180 endDegree:endDegree+180 pathCenter:center andRadius:radius].CGPath;
        CAAnimationGroup *anims = [CAAnimationGroup animation];
        anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
        anims.removedOnCompletion = NO;
        anims.duration = 0.4f;
        anims.fillMode  = kCAFillModeForwards;
        [layer addAnimation:anims forKey:nil];
    }
    else
    {
        layer.path = [self createPathWithStartDegree:180 endDegree:endDegree+180 pathCenter:center andRadius:radius].CGPath;
    }
    
    
    [self displayData:currentvalue];
}

-(void)displayValues:(NSInteger )value
{
    
    
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

