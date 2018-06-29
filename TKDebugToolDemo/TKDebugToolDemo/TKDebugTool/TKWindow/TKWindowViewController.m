//
//  TKWindowViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKWindowViewController.h"
#import "Masonry.h"
#define BALLW 80
@interface TKWindowViewController ()
@property(nonatomic, assign) CGPoint previousPoint;
@end

@implementation TKWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置界面
    [self setupUI];
    //设置手势
    [self setupGestureRecognizer];
}

/**
 设置UI界面
 */
- (void)setupUI{
    self.view.frame = CGRectMake(0, 0, BALLW, BALLW);
    //底部视图
    UIView *sBallView = [[UIView alloc] initWithFrame:self.view.bounds];
    sBallView.backgroundColor = [UIColor orangeColor];
    sBallView.layer.cornerRadius = BALLW/2;
    sBallView.layer.masksToBounds = YES;
    [self.view addSubview:sBallView];
    
    //细线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [sBallView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.width.equalTo(sBallView);
        make.centerY.equalTo(sBallView);
        make.left.mas_equalTo(0);
    }];
    
    //显示内存使用
    UILabel *memoryLabel = [[UILabel alloc] init];
    memoryLabel.textColor = [UIColor whiteColor];
    memoryLabel.text = @"loading";
    memoryLabel.font = [UIFont systemFontOfSize:12];
    [sBallView addSubview:memoryLabel];
    [memoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sBallView);
        make.bottom.equalTo(lineView.mas_top);
    }];
    //显示cpu使用
    UILabel *cpuLabel = [[UILabel alloc] init];
    cpuLabel.textColor = [UIColor whiteColor];
    cpuLabel.text = @"loading";
    cpuLabel.font = [UIFont systemFontOfSize:12];
    [sBallView addSubview:cpuLabel];
    [cpuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sBallView);
        make.top.equalTo(lineView.mas_bottom);
    }];
}

/**
 设置手势
 */
- (void)setupGestureRecognizer{
    //添加拖动手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResponse:)];
    [self.view addGestureRecognizer:panGR];
}

/**
 监听滑动手势
 @param panGR 手势
 */
- (void)panResponse:(UIPanGestureRecognizer *)panGR{
    //获取当前chu'mo'dia
    CGPoint currentPoint = ([panGR locationInView:[UIApplication sharedApplication].keyWindow];
    if (panGR.state == UIGestureRecognizerStateBegan) {
        self.previousPoint =
    } else if (panGR.state == UIGestureRecognizerStateChanged){
        
    } else if (panGR.state == UIGestureRecognizerStateEnded ||
               panGR.state == UIGestureRecognizerStateEnded ||
               panGR.state == UIGestureRecognizerStateEnded){
        
    }
}



@end
