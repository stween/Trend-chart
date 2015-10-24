//
//  ChatLine.m
//  走势图绘制
//
//  Created by jinpengyao on 15/8/17.
//  Copyright (c) 2015年 JPY. All rights reserved.
//
#import "ChatLineView.h"
#import "PointBtn.h"
#define rowNum 5
#define distanceToBtm 30

//#define horizontalSpace 23.5
#define verticalSpace 0.065
#define distanceToLeft 8


@interface ChatLineView()
/**
 *  间隔数值
 */
@property(nonatomic,assign)CGFloat spaceValue;


@property(nonatomic, strong) NSMutableArray *yValueArr;

@property(nonatomic, strong) UIColor *selectColor;

@property(nonatomic, assign) CGFloat horizontalSpace;

@property(nonatomic, assign) int level;

@property(nonatomic, strong) NSMutableArray *pointArr;

@property(nonatomic, assign) int minValue;

@end

@implementation ChatLineView

-(NSMutableArray *)pointArr{
    if(!_pointArr){
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}

-(NSMutableArray *)yValueArr{
    if(!_yValueArr){
        self.yValueArr = [NSMutableArray array];
    }
    return _yValueArr;
}

//绘制图形
- (void)drawRect:(CGRect)rect {
    //适配机型
    [self autoGetScale];
    //1绘制纵轴
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor]set];
    NSString *unitYStr = self.unitYStr;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];//设置
    [unitYStr drawInRect:CGRectMake(distanceToLeft,0,100,10) withFont:font];
    for (int i = 0 ; i < self.valueArr.count ; i++) {
        if(i == 0){
            [[UIColor colorWithRed:255.0/255.0 green:135.0/255.0 blue:51.0/255.0 alpha:1.0] set];
            self.selectColor = [UIColor colorWithRed:255.0/255.0 green:135.0/255.0 blue:51.0/255.0 alpha:1.0];
            
        }else{
            [[UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:192.0/255.0 alpha:1.0]set];
            self.selectColor = [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:192.0/255.0 alpha:1.0];
        }
        float x = (distanceToLeft + 60) * (i + 1) + 80;
        float y = 8;
        PointBtn *showPoint = [[PointBtn alloc]initWithFrame:CGRectMake(x - 4, y - 4, 8, 8)];
        [showPoint setBackgroundImage:[UIImage imageNamed:@"circlepoint"] forState:UIControlStateNormal];
        showPoint.backgroundColor = self.selectColor;
        showPoint.layer.cornerRadius = 4;
        showPoint.layer.masksToBounds = YES;
        showPoint.userInteractionEnabled = NO;
        [self addSubview:showPoint];
        UIFont *font = [UIFont boldSystemFontOfSize:15.0];//设置
        [self.yearArr[i] drawInRect:CGRectMake(x + 10 ,0,40,10) withFont:font];
    }
    
    [[UIColor lightGrayColor]set];
    for (int i = 0 ; i < self.yValueArr.count ; i++) {
        [self.yValueArr[i] drawInRect:CGRectMake(distanceToLeft,(self.yValueArr.count - i) * self.horizontalSpace,30,10) withFont:font];
    }
    //1.1绘制虚线
    for (int i = 0 ; i < self.yValueArr.count ; i++) {
        CGContextMoveToPoint(context, distanceToLeft + 30, (self.yValueArr.count - i) * self.horizontalSpace + 8);
        CGContextAddLineToPoint(context, (self.xValueArr.count + 2.1) * (rect.size.width * verticalSpace), (self.yValueArr.count - i) * self.horizontalSpace + 8);
        //这里为其单独设置虚线
        CGFloat lengths[] = {3,1};
        CGContextSetLineDash(context, 0, lengths, 2);
        CGContextStrokePath(context);
    }
    
    //2绘制横轴
    for (int i = 0 ; i < self.xValueArr.count ; i++) {
        [self.xValueArr[i] drawInRect:CGRectMake((i + 2) * (rect.size.width * verticalSpace),(self.yValueArr.count + 1) * self.horizontalSpace ,30 ,10) withFont:font];
    }
    NSString *unitXStr = @"(月)";
    [unitXStr drawInRect:CGRectMake((self.xValueArr.count + 2.1) * (rect.size.width * verticalSpace),(self.yValueArr.count + 1) * self.horizontalSpace ,30 ,10) withFont:font];
    
    //3绘制点
    for (int i = 0 ; i < self.valueArr.count ; i++) {
        NSArray *subArr = self.valueArr[i];
        if(i == 0){
            [[UIColor colorWithRed:255.0/255.0 green:135.0/255.0 blue:51.0/255.0 alpha:1.0] set];
            self.selectColor = [UIColor colorWithRed:255.0/255.0 green:135.0/255.0 blue:51.0/255.0 alpha:1.0];
            
        }else{
            [[UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:192.0/255.0 alpha:1.0]set];
            self.selectColor = [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:192.0/255.0 alpha:1.0];
        }
   
        for (int j = 0 ; j < subArr.count ; j++) {
            
            float y = (self.yValueArr.count -  [subArr[j] intValue] / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
            float x =  (j + 2) * (rect.size.width * verticalSpace)+ 5 ;
            PointBtn *clickBtn = [[PointBtn alloc]initWithFrame:CGRectMake(x - 4, y - 4, 8, 8)];
            [clickBtn setBackgroundImage:[UIImage imageNamed:@"circlepoint"] forState:UIControlStateNormal];
            clickBtn.yearStr = self.yearArr[i];
            clickBtn.valueStr = subArr[j];
            //
            clickBtn.monthStr = [NSString stringWithFormat:@"%d",j + 1];
            [clickBtn addTarget:self action:@selector(pointClick:) forControlEvents:UIControlEventTouchUpInside];
            clickBtn.tag = j;
            clickBtn.backgroundColor = self.selectColor;
            clickBtn.layer.cornerRadius = 4;
            clickBtn.layer.masksToBounds = YES;
            [self addSubview:clickBtn];
            [self.pointArr addObject:clickBtn];
        }
        
        //绘制蒙版
        //4绘制折线
        float firstY = (self.yValueArr.count -  0 / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
        float firstX =   2 * (rect.size.width * verticalSpace)+ 5 ;
        CGContextMoveToPoint(context, firstX, firstY);
        for (int j = 0 ; j < subArr.count ; j++) {
            float y = (self.yValueArr.count -  [subArr[j] intValue] / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
            float x =  (j + 2) * (rect.size.width * verticalSpace)+ 5 ;
            if(j == 0){
                CGContextMoveToPoint(context, x, y);
            }else{
                CGContextAddLineToPoint(context, x, y);
            }
        }
        CGContextSetLineWidth(context, 1.0);
        CGContextSetLineDash(context, 0, 0, 0);
        CGContextStrokePath(context);
        
        //绘制蒙版
        CGContextRef context1 = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
        //1.起始点
        CGPathMoveToPoint(path, NULL, firstX, firstY);
        for (int j = 0 ; j < subArr.count ; j++) {
            float y = (self.yValueArr.count -  [subArr[j] intValue] / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
            float x =  (j + 2) * (rect.size.width * verticalSpace)+ 5 ;
            CGPathAddLineToPoint(path, NULL, x, y);
        }
        
        //2.绘制终点
        float lastY = (self.yValueArr.count -  0 / (self.spaceValue * self.level) ) * self.horizontalSpace + 8;
        float lastX =  (subArr.count + 1) * (rect.size.width * verticalSpace)+ 5;
        CGPathAddLineToPoint(path, NULL, lastX, lastY);
        CGContextSetLineWidth(context1, 3.0);
        CGContextSetLineDash(context1, 0, 0, 0);
        if(i == 0){
            [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:255.0/255.0 green:135.0/255.0 blue:51.0/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
        }else{
            [self drawLinearGradient:context1 path:path startColor:[UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:192.0/255.0 alpha:0.1].CGColor endColor:[UIColor whiteColor].CGColor];
        }
    }
}

-(void)setValueArr:(NSArray *)valueArr{
    _valueArr = valueArr;
    //找出所有数组中的最大值与最小值
    int maxValue = 0;
    NSString *minStrValue = self.valueArr[0][0];
    int minValue = [minStrValue intValue];
    for (int i = 0 ; i < self.valueArr.count; i++) {
        NSArray *subArr = self.valueArr[i];
        for (int j = 0 ; j < subArr.count ; j++) {
            int compareValue = [subArr[j] intValue];
            if(maxValue < compareValue){
                maxValue = compareValue;
            }
            if(minValue > compareValue){
                minValue = compareValue;
            }
        }
    }
    self.spaceValue = (maxValue  / [self getUnitWithMaxValue:maxValue]) / (rowNum - 1);
    int spaceInt = self.spaceValue;
    for (int i = 0 ; i < rowNum + 1; i++) {
        NSString *value = [NSString stringWithFormat:@"%d",spaceInt * i];
        [self.yValueArr addObject:value];
    }
}

-(void)pointClick:(PointBtn *)clickBtn{
    /**
     *年
     */
    UILabel *yearLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
    yearLable.text = [NSString stringWithFormat:@"%@年%@月",clickBtn.yearStr,clickBtn.monthStr];
    [yearLable sizeToFit];
    /**
     *金额
     */
    UILabel *moneyLable = [[UILabel alloc]init];
    moneyLable.text = [NSString stringWithFormat:@"金额:%@元",clickBtn.valueStr];
    [moneyLable sizeToFit];
    
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - (yearLable.frame.size.width + moneyLable.frame.size.width) / 2 , 20, yearLable.frame.size.width + moneyLable.frame.size.width , 30)];
    showView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    yearLable.frame = CGRectMake(0, 0, yearLable.frame.size.width, 30);
    moneyLable.frame =CGRectMake(CGRectGetMaxX(yearLable.frame), 0, moneyLable.frame.size.width, 30);
    [showView addSubview:yearLable];
    [showView addSubview:moneyLable];
    [self addSubview:showView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        yearLable.alpha = 0;
        moneyLable.alpha = 0;
        showView.alpha = 0;
        [showView removeFromSuperview];
    });
}


-(void)autoGetScale{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(screenHeight == 480){//4s
        self.horizontalSpace = 13;
    }else if(screenHeight == 568){//5-5s
        self.horizontalSpace = 16.5;
    }else if(screenHeight == 667){//6
        self.horizontalSpace = 20.5;
    }else if(screenHeight == 736){//6p 414
        self.horizontalSpace = 23.5;
    }
}


-(int )getUnitWithMaxValue:(int )maxValue{
    int unitNum = 0;
    int tempValue = 1;
    for(int i = 0 ; true ; i++){
        tempValue *= 10;
        if((maxValue / tempValue) == 0){
            unitNum = i + 1;
            break;
        }
    }
    switch (unitNum) {
        case 1:
        case 2:
        case 3:
        case 4://以百为单位 10,00
            self.level = tempValue/ 100;
            self.unitYStr = @"销售额(百)";
            break;
        case 5://以千为单位 10,000
            self.level = tempValue/ 100;
            self.unitYStr = @"销售额(千)";
            break;
        case 6://以万为单位 10,0000
            self.level = tempValue/ 100;
            self.unitYStr = @"销售额(万)";
            break;
        case 7://以十万为单位 10,00000
            self.level = tempValue / 100;
            self.unitYStr = @"销售额(十万)";
            break;
        case 8://以百万为单位 10,000000
            self.level = tempValue/ 100;
            self.unitYStr = @"销售额(百万)";
            break;
        case 9://以千万为单位 10,0000000
            self.level = tempValue/ 100;
            self.unitYStr = @"销售额(千万)";
            break;
        case 10://以亿为单位 10,00000000
            self.level = tempValue/ 100;
            self.unitYStr = @"销售额(亿)";
            break;
        default:
            break;
    }
    return self.level;
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
