//
//  BarGraph.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 08/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "BarGraph.h"
#import "MyShapeLayer.h"

@implementation BarGraph
{
    UILabel *graphName;
    
    BOOL isGraphValidDimensions;
    BOOL isScreenFitGraph;
    
    CGFloat WIDTH;
    CGFloat HEIGHT;
    CGFloat maxXValue;
    CGFloat maxYValue;
    CGFloat barWidth;
    
    UIScrollView *scrollView;
    
    UIViewController * mainScreenView;
    UIView *scrollViewUI;
    
}

-(void)drawRect:(CGRect)rect
{
    if(100<rect.size.height  && 100 <rect.size.width )
    {
        HEIGHT = self.frame.size.height;
        WIDTH = self.frame.size.width;
        isGraphValidDimensions =YES;
        isScreenFitGraph =YES;
        barWidth = 10;
        scrollViewUI.multipleTouchEnabled =YES;
        
    }
    else
    {
        isGraphValidDimensions =NO;
    }
}



-(void)setUpBarGraph:(UIViewController*)mainView
{
    [self resetChart];
    mainScreenView = mainView;
    if(isGraphValidDimensions)
    {
        
        // Draw X Line
        [self drawLineWithStartPoints:CGPointMake(LEFT_PADDING, TOP_PADDING) endPoints:CGPointMake(LEFT_PADDING, HEIGHT-BOTTOM_PADDING) lineWidth:DEFAULT_LINE_WIDTH andLineColor:[UIColor blackColor] addOnView:self xValue:0 andYValue:0 tag:-1];
        

        
    }
}

- (void)showXYValue:(MyShapeLayer *)shapeLayer
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Details"
                                                                   message:[NSString stringWithFormat:@" X Value Is  %.0f And Y Value Is %.0f !",shapeLayer.xValue,shapeLayer.yValue] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    
    
    [alert addAction:close];
    [mainScreenView presentViewController:alert
                       animated:YES
                     completion:nil];
    
}

-(void)resetChart
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.layer.sublayers =nil;
}





-(void)drawLineWithStartPoints:(CGPoint)startPoint endPoints:(CGPoint)endPoint lineWidth:(double)lineWidth andLineColor:(UIColor*)color addOnView:(UIView*)view xValue:(CGFloat)xValue andYValue:(CGFloat) yValue tag:(NSInteger)tag
{
    
    CGPoint startPointParent=startPoint;
    CGPoint endPointParent=endPoint;
    startPointParent.x= startPointParent.x+self.frame.origin.x;
    startPointParent.y = startPointParent.y+self.frame.origin.y;

    endPointParent.x = endPointParent.x+self.frame.origin.x;
    endPointParent.y = endPointParent.y +self.frame.origin.y;
    
    
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    MyShapeLayer *shapeLayer = [MyShapeLayer layer];
    
    shapeLayer.path = [path CGPath];
    
    if(color)
    {
        [shapeLayer addAnimation:[self animationFillUpStartColor:[UIColor whiteColor] andEndColor:color] forKey:COLOR_KEY];
        shapeLayer.strokeColor = [color CGColor];
    }
    else
    {
        [shapeLayer addAnimation:[self animationFillUpStartColor:[UIColor whiteColor] andEndColor:[UIColor darkGrayColor]] forKey:COLOR_KEY];
        shapeLayer.strokeColor = [[UIColor darkGrayColor] CGColor];
    }
    
    if(lineWidth)
    {
        shapeLayer.lineWidth = lineWidth;
    }
    else
    {
        shapeLayer.lineWidth = DEFAULT_LINE_WIDTH;
    }
    
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    shapeLayer.tag=tag;
    shapeLayer.xValue=xValue;
    shapeLayer.yValue=yValue;
    shapeLayer.layerWidth = lineWidth;
    shapeLayer.xPoint = startPoint.x;
    shapeLayer.yPoint = startPoint.y;
    shapeLayer.color =color;
    shapeLayer.startPoints = startPointParent;
    shapeLayer.endPoints = endPointParent;
    
    [view.layer addSublayer:shapeLayer];
    
}

-(CABasicAnimation*)animationFillUpStartColor:(UIColor*)startColor andEndColor:(UIColor*)endColor
{
    CABasicAnimation *fillUp = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    fillUp.fromValue = (__bridge id _Nullable)([startColor CGColor]);
    fillUp.toValue = (__bridge id _Nullable)([endColor CGColor]);
    fillUp.duration = 2;
    fillUp.repeatCount= 1;
    return  fillUp;
}


-(void)setGraphName:(NSString*)name
{
    if (isGraphValidDimensions) {
        
        graphName = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING, HEIGHT-25, WIDTH-LEFT_PADDING, LABEL_HEIGHT)];
        graphName.text = name;
        [graphName setTextAlignment:NSTextAlignmentCenter];
        [graphName setFont:[UIFont boldSystemFontOfSize:12]];
        [self addSubview:graphName];
    }
    
}

-(void)setUpXValueLable
{
    if((int)maxXValue % 5 != 0)
    {
        maxXValue = maxXValue - (int)maxXValue %5;
        maxXValue = maxXValue +5;
    }
    
    CGFloat valuesGap = maxXValue/5;
    CGFloat distance = (HEIGHT - (TOP_PADDING+BOTTOM_PADDING))/6;
    CGFloat startPoint = HEIGHT - BOTTOM_PADDING;
    for(int i = 0; i <= 5; i++)
    {
        CGFloat yPoint = startPoint - distance *i;
        
        // x values
        [self drawLabelWithText:[NSString stringWithFormat:@"%ld",(long)valuesGap*i]
                 andXYPositions:CGPointMake(5, yPoint-(LABEL_HEIGHT/2))
                    andFontSize:XYVALUE_FONT_SIZE
                      addOnView:self];
        
        
        CGFloat yLightPoint = (HEIGHT-BOTTOM_PADDING) - distance *i;
        // X Axis Light Weight Lines
        [self drawLineWithStartPoints:CGPointMake(LEFT_PADDING, yLightPoint)
                            endPoints:CGPointMake(WIDTH-RIGHT_PADDING, yLightPoint)
                            lineWidth:0.1
                         andLineColor:[UIColor grayColor]
                            addOnView:self xValue:0 andYValue:0 tag:-1];
    }
}



-(NSArray*)sortYArray:(NSMutableArray*)values
{
    NSMutableArray *yValues=[NSMutableArray array];
    
    for(int i=0;i<values.count;i++)
    {
        [yValues addObject:[[values objectAtIndex:i]objectForKey:Y_VALUE_KEY]];
    }
    
    for(int i=0;i<values.count;i++)
    {
        for(int j=0;j<values.count;j++)
        {
            if([[yValues objectAtIndex:i] intValue] > [[yValues objectAtIndex:j] intValue] )
            {
                
                NSString *tempi = [yValues objectAtIndex:i];
                NSString *tempj = [yValues objectAtIndex:j];
                [yValues replaceObjectAtIndex:i withObject:tempj];
                [yValues replaceObjectAtIndex:j withObject:tempi];
                
            }
        }
    }
    return yValues;
}

-(void)setUpYValueLableWithValueArray:(NSArray*)values
{
    
    if((int)maxYValue % 10 != 0)
    {
        maxYValue = maxYValue - (int)maxYValue %10;
        maxYValue = maxYValue +10;
    }
    
    CGFloat valuesGap = maxYValue/5;
    CGFloat distance = scrollViewUI.frame.size.width/6;
    
    NSArray *sortedYValues = [self sortYArray:[values mutableCopy]];
    
    
    for(int i=12;i>5;i--)
    {
        isScreenFitGraph = YES;
        if(scrollViewUI.frame.size.width/i >= values.count)
        {
            for(int x=0;x<(values.count)-1;x++)
            {
                CGFloat ypoint2 = distance * ([[sortedYValues objectAtIndex:x+1] floatValue]/valuesGap);
                CGFloat ypoint1 = distance * ([[sortedYValues objectAtIndex:x] floatValue]/valuesGap);
                
                if((ypoint1-(i/2))-(ypoint2+(i/2)) < i)
                {
                    isScreenFitGraph =NO;
                    x=(int)values.count;
                }
            }
            
            if(isScreenFitGraph)
            {
                barWidth = i-2;
                break;
            }
            
        }
    }
    
    if(isScreenFitGraph)
    {
        distance = scrollViewUI.frame.size.width/6;
    }
    else
    {
        distance = (maxYValue * 12)/6;
        barWidth =10;
    }
    
    CGFloat xPoint =0;
    
    
    
    for(int i = 0; i <= 5; i++)
    {
        
        xPoint = distance * i;
        
        // Y values
        [self drawLabelWithText:[NSString stringWithFormat:@"%ld",(long)valuesGap*i]
                 andXYPositions:CGPointMake(xPoint-(LABEL_WIDTH/2), scrollViewUI.frame.size.height-15)
                    andFontSize:XYVALUE_FONT_SIZE
                      addOnView:scrollViewUI];
        
        // Y Axis Light Weight Lines
        [self drawLineWithStartPoints:CGPointMake(xPoint, scrollViewUI.frame.size.height-15)
                            endPoints:CGPointMake(xPoint, 0)
                            lineWidth:0.1
                         andLineColor:[UIColor grayColor]
                            addOnView:scrollViewUI xValue:0 andYValue:0 tag:-1];
        
    }
    
    if(!isScreenFitGraph)
    {
    CGRect newFrame = scrollViewUI.frame;
    newFrame.size.width = xPoint+distance;
    scrollViewUI.frame=newFrame;
    }
}




-(void)drawLabelWithText:(NSString*)value andXYPositions:(CGPoint)position andFontSize:(NSInteger)size addOnView:(UIView*)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(position.x, position.y, LABEL_WIDTH, LABEL_HEIGHT)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:size]];
    [label setText:value];
    [view addSubview:label];
}



-(CGFloat)getMaxValueFromArrayOfDictUsingKey:(NSArray*)dict andKey:(NSString*)key
{
    
    CGFloat tempMax=0;
    for(int i=0; i<dict.count;i++)
    {
        CGFloat temp = (CGFloat)[[[dict objectAtIndex:i] objectForKey:key] doubleValue];
        if(tempMax < temp)
        {
            tempMax =temp;
        }
    }
    return tempMax;
}




-(void)setUpScrollViewWithInnerView
{

    scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(LEFT_PADDING+1, TOP_PADDING, WIDTH-(LEFT_PADDING+RIGHT_PADDING), (HEIGHT-(TOP_PADDING+BOTTOM_PADDING))+15)];
    
    
    scrollViewUI.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    
    scrollViewUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    scrollViewUI.backgroundColor =[UIColor whiteColor];
    
    
    
    [scrollView addSubview:scrollViewUI];
    scrollView.bounces =NO;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWork:)];
    singleTap.numberOfTapsRequired =1;
    [scrollViewUI addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapWork:)];
    doubleTap.numberOfTapsRequired =2;
    [scrollViewUI addGestureRecognizer:singleTap];
    [scrollViewUI addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
}

// ================================= Draw Bar Graph =====================//
#pragma mark Draw BarGraph

-(void)drawBarGraph:(NSArray *)values
{
    if(isGraphValidDimensions)
    {
        
        maxXValue = [self getMaxValueFromArrayOfDictUsingKey:values andKey:X_VALUE_KEY];
        maxYValue = [self getMaxValueFromArrayOfDictUsingKey:values andKey:Y_VALUE_KEY];
        [self setUpScrollViewWithInnerView];
        
       
        [self setUpYValueLableWithValueArray:values];
        scrollView.contentSize = scrollViewUI.frame.size;
        // Draw Y Line
        [self drawLineWithStartPoints:CGPointMake(0, scrollViewUI.frame.size.height-15)
                            endPoints:CGPointMake(scrollViewUI.frame.size.width, scrollViewUI.frame.size.height-15) lineWidth:DEFAULT_LINE_WIDTH andLineColor:[UIColor blackColor] addOnView:scrollViewUI xValue:0 andYValue:0 tag:-1];
        [self setUpXValueLable];
    
        
        CGFloat xvaluesGap = maxXValue/5;
        CGFloat xdistance = (scrollViewUI.frame.size.height-15)/6;
        
        CGFloat yvaluesGap = maxYValue/5;
        CGFloat ydistance = scrollViewUI.frame.size.width/6;
        for(int i = 0; i<values.count; i++)
        {
            CGFloat xValue = (CGFloat)[[[values objectAtIndex:i] objectForKey:X_VALUE_KEY] doubleValue];
            CGFloat yValue = (CGFloat)[[[values objectAtIndex:i] objectForKey:Y_VALUE_KEY] doubleValue];
            UIColor *color = (UIColor*)[[values objectAtIndex:i] objectForKey:COLOR_KEY];
         
            CGFloat xpoint = xdistance * (xValue/xvaluesGap);
                ydistance = scrollViewUI.frame.size.width/6;
         
            CGFloat ypoint = ydistance * (yValue/yvaluesGap);
            
            
            
            // Drawing Bar Line With XValue and XPosition
            [self drawLineWithStartPoints:CGPointMake(ypoint, (scrollViewUI.frame.size.height-xpoint)-15)
                                endPoints:CGPointMake(ypoint, scrollViewUI.frame.size.height-15)
                                lineWidth:barWidth-2
                             andLineColor:color
                                addOnView:scrollViewUI
                                   xValue:xValue
                                andYValue:yValue
                                      tag:i+1];
        }
        
        
    }
}


-(void)singleTapWork:(UIGestureRecognizer *)recognizer
{
    
    CGPoint touchLocation = [recognizer locationInView:scrollViewUI];
    for (id sublayer in scrollViewUI.layer.sublayers)
    {
        BOOL touchInLayer = NO;
        if ([sublayer isKindOfClass:[MyShapeLayer class]])
        {
            MyShapeLayer *shapeLayer = sublayer;
            
            if(0 < shapeLayer.tag)
            {
                if((touchLocation.x > shapeLayer.xPoint -(shapeLayer.layerWidth/2) && touchLocation.x < shapeLayer.xPoint+(shapeLayer.layerWidth/2)) &&(0 < touchLocation.y && shapeLayer.yPoint < touchLocation.y))
                {
                    NSLog(@"xvalue %.0f And yValue %.0f And Tag Is %ld ",shapeLayer.xValue,shapeLayer.yValue,(long)shapeLayer.tag);
                    touchInLayer = YES;
                    [self showXYValue:shapeLayer];
                }
                
            }
        }
        
    }
}



-(void)showBarZoom:(MyShapeLayer*)shapeLayer andstartPoint:(CGPoint)startPoint andEndpoint:(CGPoint)endPoint
{
    [mainScreenView.view endEditing:YES];
    UIView *newLayer = [[UIView alloc]initWithFrame:mainScreenView.view.frame];
    newLayer.backgroundColor = [UIColor colorWithRed:204/255 green:204/255 blue:204/255 alpha:0.5];
    [mainScreenView.view addSubview:newLayer];
    
    UILabel *xValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, mainScreenView.view.frame.size.height/8, 120, 30) ];
    [xValueLabel setText:[NSString stringWithFormat:@"X Value : %0.f ",shapeLayer.xValue]];
    xValueLabel.textColor = [UIColor whiteColor];
    [newLayer addSubview:xValueLabel];
    
    UILabel *yValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, mainScreenView.view.frame.size.height-(mainScreenView.view.frame.size.height/8), 120, 30) ];
    [yValueLabel setText:[NSString stringWithFormat:@"Y Value : %0.f ",shapeLayer.yValue]];
    yValueLabel.textColor = [UIColor whiteColor];
    [newLayer addSubview:yValueLabel];
    
    
    
    
    
    UIBezierPath *newpath = [UIBezierPath bezierPath];
    [newpath moveToPoint:startPoint];
    [newpath addLineToPoint:endPoint];
    
    MyShapeLayer *newShapeLayer = [MyShapeLayer layer];
    newShapeLayer.tag =1;
    newShapeLayer.startPoints = startPoint;
    newShapeLayer.endPoints = endPoint;
    newShapeLayer.path = [newpath CGPath];
    newShapeLayer.lineWidth = shapeLayer.lineWidth;
    newShapeLayer.layerWidth = shapeLayer.layerWidth;
    if(shapeLayer.color == nil)
    {
        newShapeLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    }
    else
    {
        newShapeLayer.strokeColor = [shapeLayer.color CGColor];
    }
    
    [newLayer.layer addSublayer:newShapeLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(mainScreenView.view.frame.size.width/2,mainScreenView.view.frame.size.height/8)];
    [path addLineToPoint:CGPointMake(mainScreenView.view.frame.size.width/2,mainScreenView.view.frame.size.height-mainScreenView.view.frame.size.height/8)];
    
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.toValue = (id)path.CGPath;
    CABasicAnimation * widthSize = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    widthSize.fromValue = [NSNumber numberWithInt:shapeLayer.layerWidth];
    widthSize.toValue = [NSNumber numberWithInt:30];
    
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim,widthSize, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 1.0f;
    anims.fillMode  = kCAFillModeForwards;
    [newShapeLayer addAnimation:anims forKey:nil];
    
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWorkClose:)];
    [newLayer addGestureRecognizer:singleTap];
}

-(void)singleTapWorkClose:(UIGestureRecognizer *)recognizer
{
    MyShapeLayer *shapeLayer= [MyShapeLayer layer];
    UIView *tempView = recognizer.view;
    for (id sublayer in tempView.layer.sublayers)
    {
        if ([sublayer isKindOfClass:[MyShapeLayer class]])
        {
            shapeLayer = sublayer;
        }
    }
    
    UIBezierPath *newpath = [UIBezierPath bezierPath];
    [newpath moveToPoint:shapeLayer.startPoints];
    [newpath addLineToPoint:shapeLayer.endPoints];
    
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.toValue = (id)newpath.CGPath;
    CABasicAnimation * widthSize = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    widthSize.fromValue = [NSNumber numberWithInt:30];
    widthSize.toValue = [NSNumber numberWithInt:shapeLayer.layerWidth];
    
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim,widthSize, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 1.0f;
    anims.fillMode  = kCAFillModeForwards;
    [shapeLayer addAnimation:anims forKey:nil];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tempView removeFromSuperview];
    });
}

-(void)doubleTapWork:(UIGestureRecognizer *)recognizer
{
   
    CGPoint touchLocation = [recognizer locationInView:scrollViewUI];
    
    NSLog(@"TOuch Loc : %f %f",touchLocation.x,touchLocation.y);
    for (id sublayer in scrollViewUI.layer.sublayers)
    {
        
        if ([sublayer isKindOfClass:[MyShapeLayer class]])
        {
            MyShapeLayer *shapeLayer = sublayer;
            
            if(0 < shapeLayer.tag)
            {
                if((touchLocation.x > shapeLayer.xPoint -(shapeLayer.layerWidth/2) && touchLocation.x < shapeLayer.xPoint+(shapeLayer.layerWidth/2)) &&(0 < touchLocation.y && shapeLayer.yPoint < touchLocation.y))
                {
                    NSLog(@"xvalue %.0f And yValue %.0f And Tag Is %ld ",shapeLayer.xValue,shapeLayer.yValue,(long)shapeLayer.tag);
                    CGPoint startPoint =  [scrollViewUI convertPoint:scrollViewUI.frame.origin fromView:[UIApplication sharedApplication].keyWindow];
                    startPoint.x = shapeLayer.startPoints.x + (0-startPoint.x);
                    startPoint.y = shapeLayer.startPoints.y + (0-startPoint.y);
                    
                    CGPoint endPoint =  [scrollViewUI convertPoint:scrollViewUI.frame.origin fromView:[UIApplication sharedApplication].keyWindow];
                    endPoint.x = shapeLayer.endPoints.x + (0-endPoint.x);
                    endPoint.y = shapeLayer.endPoints.y + (0-endPoint.y);
                    [self showBarZoom:shapeLayer andstartPoint:(CGPoint)startPoint andEndpoint:(CGPoint)endPoint];
                }
                
            }
        }
        
    }
}


@end
