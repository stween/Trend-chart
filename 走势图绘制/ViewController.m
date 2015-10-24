//
//  ViewController.m
//  走势图绘制
//
//  Created by jinpengyao on 15/8/17.
//  Copyright (c) 2015年 JPY. All rights reserved.
//

#import "ViewController.h"
#import "ChatLineView.h"

@interface ViewController ()

@property(nonatomic,strong) NSMutableArray *yearArr;

/**
 *  走势图
 */
@property (nonatomic, weak) UIView *trendChartView;
@property (nonatomic, weak) ChatLineView *lineChartView;

@end

@implementation ViewController

-(NSMutableArray *)yearArr{
    if(!_yearArr){
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ChatLineView *chatLineView = [[ChatLineView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    chatLineView.backgroundColor = [UIColor whiteColor];
    NSArray *valueArr1 = @[@"0",@"75",@"90",@"70",@"0",@"70",@"60",@"50",@"70",@"60",@"120",@"80"];
    NSString *valueArr1Year = @"2015";
    [self.yearArr addObject:valueArr1Year];
    NSArray *valueArr2 = @[@"90",@"70",@"80",@"60",@"80",@"0",@"70",@"80",@"0",@"90",@"110",@"130"];
    NSString *valueArr2Year = @"2014";
    [self.yearArr addObject:valueArr2Year];
    chatLineView.valueArr = @[valueArr1,valueArr2];
    chatLineView.yearArr = self.yearArr;
    chatLineView.xValueArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    [self.view addSubview:chatLineView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

/**
 *  走势图
 */
-(void)addTrendChartView{
    ChatLineView *chatLineView = [[ChatLineView alloc]initWithFrame:self.trendChartView.bounds];
    self.lineChartView = chatLineView;
    [self addValueForChartView];
}

/**
 *  为走势图添加值
 */
-(void)addValueForChartView{
    self.lineChartView.backgroundColor = [UIColor whiteColor];
    NSArray *valueArr1 = @[@"1000",@"15000",@"90000",@"70000",@"30000",@"40000",@"20000",@"50000",@"20000",@"60000",@"120000",@"80000"];
    NSString *valueArr1Year = @"2015";
    [self.yearArr addObject:valueArr1Year];
    NSArray *valueArr2 = @[@"90000",@"70000",@"50000",@"60000",@"20000",@"50000",@"10000",@"80000",@"70000",@"20000",@"110000",@"130000"];
    NSString *valueArr2Year = @"2014";
    [self.yearArr addObject:valueArr2Year];
    self.lineChartView.yearArr = @[valueArr1,valueArr2];
    self.lineChartView.valueArr = @[valueArr1,valueArr2];
    self.lineChartView.yearArr = self.yearArr;
    self.lineChartView.xValueArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    [self.trendChartView addSubview:self.lineChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
