//
//  DonutChart.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 22/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "DonutChart.h"

@implementation DonutChart
{
    UILabel *graphName;
    
    BOOL isGraphValidDimensions;
    BOOL isAnyLayerClicked;
    
    CGRect mainRect;
    
    CGFloat WIDTH;
    CGFloat HEIGHT;
    CGFloat maxXValue;
    CGPoint center;
    CGFloat radius;
    CGFloat startDegree;
    CGFloat singleDegreeValue;
    
    MyShapeLayer *clickedLayer;
    
    
    UIBezierPath *mainCirclePath;
    
    UIScrollView *scrollView;
    
    UIView *scrollViewUI;
    
    NSMutableArray *barValueArrray;
    
    NSInteger sumOfValues;
    NSInteger index;
    
    UITableView *tableViewDynamic;
    
    NSTimer *_timer;
}

-(void)drawRect:(CGRect)rect
{
    isAnyLayerClicked = NO;
    WIDTH = 300;
    HEIGHT = 300;
    index = 0;
    if(300<rect.size.height)
    {
        HEIGHT = self.frame.size.height;
    }
    if (300 <rect.size.width )
    {
        WIDTH = self.frame.size.width;
    }
    center = CGPointMake((WIDTH-100)/2,HEIGHT/2);
    radius = center.x - 20.f;
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
    
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWork:)];
    singleTap.numberOfTapsRequired =1;
    [scrollViewUI addGestureRecognizer:singleTap];
    
    //    UITapGestureRecognizer *doubleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapWork:)];
    //    doubleTap.numberOfTapsRequired =2;
    //    [scrollViewUI addGestureRecognizer:singleTap];
    //    [scrollViewUI addGestureRecognizer:doubleTap];
    //    [singleTap requireGestureRecognizerToFail:doubleTap];
    
}

-(void)animationOnPathOfLayer:(MyShapeLayer*)shapeLayer
{

    UIBezierPath *portionPath1 = [UIBezierPath bezierPath];
    [portionPath1 moveToPoint:center];
    
    [portionPath1 addArcWithCenter:center radius:radius+5 startAngle:degreesToRadians(shapeLayer.startDegree+2) endAngle:degreesToRadians(shapeLayer.endDegree -2) clockwise:YES];
    
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.toValue = (id)portionPath1.CGPath;
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 0.01f;
    anims.fillMode  = kCAFillModeForwards;
    [shapeLayer addAnimation:anims forKey:@"clickAnimation"];
}

-(void)displayDataOfSelectedLayer:(MyShapeLayer*)shapeLayer
{
 
    UIFont *myFont = [UIFont systemFontOfSize:14];
    UILabel *lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(((WIDTH-100)/2)-40,(HEIGHT/2)-20, radius-10, 40)];
    lblProgress.tag =100;
    lblProgress.numberOfLines = 2;
    lblProgress.text =[NSString stringWithFormat:@"%@ \n %d%%",shapeLayer.data,(int)shapeLayer.value];
    
    lblProgress.font =  myFont;
    lblProgress.textColor =[UIColor blackColor];
    lblProgress.textAlignment = NSTextAlignmentCenter;
    [scrollViewUI addSubview:lblProgress];
}


-(void)singleTapWork:(UIGestureRecognizer *)recognizer
{
    
    CGPoint touchLocation = [recognizer locationInView:scrollViewUI];
    for (id sublayer in scrollViewUI.layer.sublayers)
    {
        
        if ([sublayer isKindOfClass:[MyShapeLayer class]])
        {
            MyShapeLayer *shapeLayer = sublayer;
            if(CGPathContainsPoint(shapeLayer.path11,0, touchLocation, YES))
            {
                if(!CGPathContainsPoint(mainCirclePath.CGPath,0, touchLocation, YES))
                {

                    if(isAnyLayerClicked)
                    {
                        if(clickedLayer == shapeLayer)
                        {
                            isAnyLayerClicked = NO;
                            [clickedLayer removeAnimationForKey:@"clickAnimation"];
                            UILabel *text = [scrollViewUI viewWithTag:100];
                            [text removeFromSuperview];
                        }
                        else
                        {
                            isAnyLayerClicked = YES;
                            [clickedLayer removeAnimationForKey:@"clickAnimation"];
                            
                            [self animationOnPathOfLayer:shapeLayer];
                            UILabel *text = [scrollViewUI viewWithTag:100];
                            [text removeFromSuperview];
                            [self displayDataOfSelectedLayer:shapeLayer];
                            clickedLayer = shapeLayer;
                        }
                    }
                    else
                    {
                        isAnyLayerClicked = YES;
                        [self animationOnPathOfLayer:shapeLayer];
                        [self displayDataOfSelectedLayer:shapeLayer];
                        clickedLayer = shapeLayer;
                    }
                    break;
                    
                }
            }
        }
        
    }
}




- (void)_timerFired:(NSTimer *)timer
{
    
    if (index==[barValueArrray count])
    {
        [timer invalidate];
        timer = nil;
        barValueArrray = [self sortArray:barValueArrray WithKey:X_VALUE_KEY];
        tableViewDynamic = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH-100, 25, 100, HEIGHT-50) style:UITableViewStylePlain];
        tableViewDynamic.dataSource=self;
        tableViewDynamic.delegate = self;
        tableViewDynamic.allowsSelection = NO;
        tableViewDynamic.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableViewDynamic.bounces = NO;
        tableViewDynamic.transform = CGAffineTransformMakeRotation(-M_PI);
        [tableViewDynamic registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        [scrollViewUI addSubview:tableViewDynamic];
        [tableViewDynamic reloadData];
    }
    else
    {
        
        
        CGPoint newCentre = center;
        CGFloat endDegree =startDegree+(singleDegreeValue * [[[barValueArrray objectAtIndex:index] objectForKey:@"xValue"] integerValue]);
        
        UIBezierPath *temp = [UIBezierPath bezierPath];
        [temp moveToPoint:newCentre];
        
        [temp addArcWithCenter:newCentre radius:radius startAngle:degreesToRadians(startDegree) endAngle:degreesToRadians(startDegree+0) clockwise:YES];
        
        UIBezierPath *portionPath = [UIBezierPath bezierPath];
        [portionPath moveToPoint:newCentre];
        
        [portionPath addArcWithCenter:newCentre radius:radius startAngle:degreesToRadians(startDegree) endAngle:degreesToRadians(endDegree) clockwise:YES];
        
        
        UIBezierPath *onClickTransfromPath = [UIBezierPath bezierPath];
        [onClickTransfromPath moveToPoint:CGPointMake(300/2, 300/2)];
        
        [onClickTransfromPath addArcWithCenter:CGPointMake(300/2, 300/2) radius:(300/2)-20 startAngle:degreesToRadians(startDegree) endAngle:degreesToRadians(endDegree) clockwise:YES];
        
//        UIBezierPath *tempValuePath = [UIBezierPath bezierPath];
//        [tempValuePath moveToPoint:newCentre];
//        [tempValuePath addArcWithCenter:newCentre radius:radius+10 startAngle:degreesToRadians(startDegree+((endDegree-startDegree)/2)) endAngle:degreesToRadians(startDegree+((endDegree-startDegree)/2)) clockwise:YES];
//        
//        
//        CGRect oldRect = portionPath.bounds;
//        
//        
//        
//        MyShapeLayer *valueLayer = [MyShapeLayer layer];
//        valueLayer.strokeColor = [UIColor blackColor].CGColor;
//        valueLayer.path = tempValuePath.CGPath;
//        valueLayer.zPosition = -2;
//        [scrollViewUI.layer addSublayer:valueLayer];
//        
        MyShapeLayer *shapeLayer = [MyShapeLayer layer];
        shapeLayer.fillColor = [[[barValueArrray objectAtIndex:index] objectForKey:COLOR_KEY] CGColor];
        shapeLayer.path = [temp CGPath];
        if(barValueArrray.count>1)
        {
            shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            shapeLayer.lineWidth = 1 ;
        }
        
        shapeLayer.startDegree = startDegree;
        shapeLayer.endDegree = endDegree;
        shapeLayer.zPosition = -1;
        shapeLayer.path11 = portionPath.CGPath;
        shapeLayer.data = [[barValueArrray objectAtIndex:index]objectForKey:@"data"];
        shapeLayer.color = [[barValueArrray objectAtIndex:index] objectForKey:COLOR_KEY];
        shapeLayer.value = [[[barValueArrray objectAtIndex:index]objectForKey:X_VALUE_KEY]doubleValue];
        shapeLayer.transformablePath = onClickTransfromPath;
        
        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnim.toValue = (id)portionPath.CGPath;
        CAAnimationGroup *anims = [CAAnimationGroup animation];
        anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
        anims.removedOnCompletion = NO;
        anims.duration = 0.1f;
        anims.fillMode  = kCAFillModeForwards;
        [shapeLayer addAnimation:anims forKey:@"pieAnimation"];
        [scrollViewUI.layer addSublayer:shapeLayer];
        
        startDegree = startDegree + (singleDegreeValue * [[[barValueArrray objectAtIndex:index] objectForKey:@"xValue"] integerValue]);
        
        
        
    }
    index++;
}
-(CGFloat)SumOfArrayValues:(NSArray *)values WithKey:(NSString *)key
{
    CGFloat sum =0;
    for(int i=0;i<values.count;i++)
    {
        sum = sum + [[[values objectAtIndex:i] objectForKey:key] integerValue];
    }
    return sum;
}

-(void)drawDonutChartWithValues:(NSArray*)values
{
    [self resetChart];
    index =0;
    barValueArrray = [NSMutableArray arrayWithArray:values];
    sumOfValues = [self SumOfArrayValues:values WithKey:X_VALUE_KEY];
    startDegree = 0;
    singleDegreeValue = (CGFloat)360 / (CGFloat)sumOfValues;
    
    mainCirclePath = [UIBezierPath bezierPath];
    [mainCirclePath moveToPoint:center];
    
    [mainCirclePath addArcWithCenter:center radius:(radius/2) startAngle:degreesToRadians(0) endAngle:degreesToRadians(360) clockwise:YES];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.fillColor = [UIColor whiteColor].CGColor;
    layer2.path = [mainCirclePath CGPath];
    [scrollViewUI.layer addSublayer:layer2];
    
    
    UIBezierPath *portionPath1 = [UIBezierPath bezierPath];
    [portionPath1 moveToPoint:center];
    
    [portionPath1 addArcWithCenter:center radius:(radius/2)+5 startAngle:degreesToRadians(0) endAngle:degreesToRadians(360) clockwise:YES];
    
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    layer3.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
    layer3.path = [portionPath1 CGPath];
    
    [scrollViewUI.layer addSublayer:layer3];
    
    
    if (index<barValueArrray.count)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(_timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return barValueArrray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCellForPieChart *cell = (CustomCellForPieChart *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.legendText.text = [NSString stringWithFormat:@"%@ %@%%",[[barValueArrray objectAtIndex:indexPath.row] objectForKey:@"data"],[[barValueArrray objectAtIndex:indexPath.row] objectForKey:X_VALUE_KEY]];
    cell.legendColor.backgroundColor = (UIColor*)[[barValueArrray objectAtIndex:indexPath.row] objectForKey:COLOR_KEY];
    
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    //cell.imageView.backgroundColor = [UIColor redColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}


-(NSMutableArray*)sortArray:(NSArray*)values WithKey:(NSString*)key
{
    NSMutableArray *sortedValues=[NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    for(int i=0;i<values.count;i++)
    {
        [sortedValues addObject:[[values objectAtIndex:i]objectForKey:key]];
        [tempArray addObject:[values objectAtIndex:i]];
    }
    
    for(int i=0;i<values.count;i++)
    {
        for(int j=0;j<values.count;j++)
        {
            if([[sortedValues objectAtIndex:i] intValue] < [[sortedValues objectAtIndex:j] intValue] )
            {
                
                NSString *tempi = [sortedValues objectAtIndex:i];
                NSString *tempj = [sortedValues objectAtIndex:j];
                [sortedValues replaceObjectAtIndex:i withObject:tempj];
                [sortedValues replaceObjectAtIndex:j withObject:tempi];
                NSArray *tempiArray = [tempArray objectAtIndex:i];
                NSArray *tempjArray = [tempArray objectAtIndex:j];
                
                [tempArray replaceObjectAtIndex:i withObject:tempjArray];
                [tempArray replaceObjectAtIndex:j withObject:tempiArray];
                
                
            }
        }
    }
    return tempArray;
}


@end

