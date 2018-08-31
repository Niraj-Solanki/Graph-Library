//
//  PieChart.m
//  CustomBarGraph
//
//  Created by Neeraj Solanki on 17/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "PieChart.h"

@implementation PieChart
{
    UILabel *graphName;
    
    BOOL isGraphValidDimensions;
    
    CGRect mainRect;
    
    CGFloat WIDTH;
    CGFloat HEIGHT;
    CGFloat maxXValue;
    CGPoint center;
    CGFloat radius;
    CGFloat startDegree;
    CGFloat singleDegreeValue;
    
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
    WIDTH = 300;
    HEIGHT = 300;
    index = 0;
    center = CGPointMake((300-100)/2,300/2);
    radius = center.x - 20.f;
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
    
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWork:)];
    singleTap.numberOfTapsRequired =1;
    [scrollViewUI addGestureRecognizer:singleTap];
    
    //    UITapGestureRecognizer *doubleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapWork:)];
    //    doubleTap.numberOfTapsRequired =2;
    //    [scrollViewUI addGestureRecognizer:singleTap];
    //    [scrollViewUI addGestureRecognizer:doubleTap];
    //    [singleTap requireGestureRecognizerToFail:doubleTap];
    
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
                // shapeLayer.path = [shapeLayer.transformablePath CGPath];
                [self showPieOnTapWithLegend:shapeLayer];
                break;
                // the touch is inside the shape
            }
        }
        
    }
}

-(void)showPieOnTapWithLegend:(MyShapeLayer *)shapeLayer
{
    [self endEditing:YES];
    UIView *newLayer = [[UIView alloc]initWithFrame:self.frame];
    newLayer.backgroundColor = [UIColor whiteColor];
    [self addSubview:newLayer];
    
    UILabel *pieDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-22, self.frame.size.width,20)];
    pieDetail.textAlignment = NSTextAlignmentCenter;
    [pieDetail setText:[NSString stringWithFormat:@"%@ : %.0f",shapeLayer.data,shapeLayer.value]];
    [pieDetail setFont:[UIFont systemFontOfSize:12]];
    [newLayer addSubview:pieDetail];
    

    
    MyShapeLayer *newShapeLayer = [MyShapeLayer layer];
    newShapeLayer.fillColor = shapeLayer.color.CGColor;
    newShapeLayer.path = shapeLayer.path11;
    newShapeLayer.path11 = shapeLayer.path11;
    if(barValueArrray.count>1)
    {
    newShapeLayer.lineWidth = 1;
    newShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.toValue = (id)shapeLayer.transformablePath.CGPath;
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 0.4f;
    anims.fillMode  = kCAFillModeForwards;
    [newShapeLayer addAnimation:anims forKey:nil];
    [newLayer.layer addSublayer:newShapeLayer];
    NSLog(@"touched");
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisUIOnTap:)];
    [newLayer addGestureRecognizer:singleTap];
}

-(void)dismisUIOnTap:(UIGestureRecognizer *)recognizer
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
    
    
    
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnim.toValue = (id)shapeLayer.path11;
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 0.4f;
    anims.fillMode  = kCAFillModeForwards;
    [shapeLayer addAnimation:anims forKey:nil];
    
    
    
    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tempView removeFromSuperview];
    });
}



- (void)_timerFired:(NSTimer *)timer
{
    
    if (index==[barValueArrray count])
    {
        [timer invalidate];
        timer = nil;
        barValueArrray = [self sortArray:barValueArrray WithKey:X_VALUE_KEY];
        tableViewDynamic = [[UITableView alloc] initWithFrame:CGRectMake(200, 25, 100, 300-50) style:UITableViewStylePlain];
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
        
        
        
        startDegree = startDegree + (singleDegreeValue * [[[barValueArrray objectAtIndex:index] objectForKey:@"xValue"] integerValue]);
    
        
        
        
        NSString *lblProgressTxt = @"100%";
        UIFont *myFont = [UIFont systemFontOfSize:10];
        CGSize size = [lblProgressTxt sizeWithAttributes:@{NSFontAttributeName:myFont}];
        CGRect oldRect = portionPath.bounds;
        UILabel *lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(oldRect)-size.width/2, CGRectGetMidY(oldRect)-size.height/2, size.width, size.height)];
        
        lblProgress.text =[NSString stringWithFormat:@"%@%%",[[barValueArrray objectAtIndex:index]objectForKey:@"xValue"]];
        lblProgress.font =  myFont;
        lblProgress.textColor =[UIColor whiteColor];
        lblProgress.textAlignment = NSTextAlignmentCenter;
        
        MyShapeLayer *shapeLayer = [MyShapeLayer layer];
        shapeLayer.fillColor = [[[barValueArrray objectAtIndex:index] objectForKey:COLOR_KEY] CGColor];
        shapeLayer.path = [temp CGPath];
        if(barValueArrray.count>1)
        {
            shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            shapeLayer.lineWidth = 1 ;
        }
    
        
        
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
        [scrollViewUI addSubview:lblProgress];
        
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

-(void)drawPieChartWithValues:(NSArray*)values
{
    [self resetChart];
    index =0;
    barValueArrray = [NSMutableArray arrayWithArray:values];
    sumOfValues = [self SumOfArrayValues:values WithKey:X_VALUE_KEY];
    startDegree = 0;
    singleDegreeValue = (CGFloat)360 / (CGFloat)sumOfValues;
    
    
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
    
    cell.legendText.text = [NSString stringWithFormat:@"%@",[[barValueArrray objectAtIndex:indexPath.row] objectForKey:@"data"]];
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
