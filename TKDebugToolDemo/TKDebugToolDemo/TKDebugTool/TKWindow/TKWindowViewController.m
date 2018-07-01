//
//  TKWindowViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKWindowViewController.h"
#import "Masonry.h"
#import "TKDebugToolMacro.h"
#define BALLW 80
@interface TKWindowViewController ()
@property(nonatomic, assign) CGPoint previousPoint;
@property(nonatomic, weak) UILabel *fpsLabel;
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
    sBallView.clipsToBounds = NO;
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
    
    //显示fps
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    fpsLabel.backgroundColor = [UIColor redColor];
    fpsLabel.text = @"60";
    fpsLabel.font = [UIFont systemFontOfSize:10];
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    fpsLabel.layer.cornerRadius = 10;
    fpsLabel.layer.masksToBounds = YES;
    fpsLabel.center = CGPointMake(0.85 * BALLW, 0.85 * BALLW);
    [sBallView addSubview:fpsLabel];
    self.fpsLabel = fpsLabel;
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
    //获取当前触摸坐标
    CGPoint currentPoint = [panGR locationInView:[UIApplication sharedApplication].keyWindow];
    if (panGR.state == UIGestureRecognizerStateBegan) {
        self.previousPoint = currentPoint;
    } else if (panGR.state == UIGestureRecognizerStateChanged){
        [self changeSuspensionBallLocation:currentPoint];
        self.previousPoint = currentPoint;
        
    } else if (panGR.state == UIGestureRecognizerStateEnded ||
               panGR.state == UIGestureRecognizerStateEnded ||
               panGR.state == UIGestureRecognizerStateEnded){
        
    }
}

/**
 改变悬浮球的位置
 */
- (void)changeSuspensionBallLocation:(CGPoint)point{
    CGFloat offsetX = point.x - self.previousPoint.x;
    CGFloat offsetY = point.y - self.previousPoint.y;
    CGRect tempFrame = self.window.frame;
    
    self.window.frame = CGRectMake(tempFrame.origin.x + offsetX, tempFrame.origin.y + offsetY, tempFrame.size.width, tempFrame.size.height);
    
    if (self.window.frame.origin.x < 0) {
        tempFrame = self.window.frame;
        tempFrame.origin.x = 0;
        self.window.frame = tempFrame;
    }
    
    if (self.window.frame.origin.x > TK_kscreenW - BALLW) {
        tempFrame = self.window.frame;
        tempFrame.origin.x = TK_kscreenW - BALLW;
        self.window.frame = tempFrame;
    }
    
    if (self.window.frame.origin.y < 0) {
        tempFrame = self.window.frame;
        tempFrame.origin.y = 0;
        self.window.frame = tempFrame;
    }
    
    if (self.window.frame.origin.y > TK_kscreenH - BALLW) {
        tempFrame = self.window.frame;
        tempFrame.origin.y = TK_kscreenH - BALLW;
        self.window.frame = tempFrame;
    }
    
    //改变fpsLabel的坐标
    if (self.window.center.y <= TK_kscreenH/2) {//位于坐标系上半部分
        
        if (self.window.center.x <= TK_kscreenW/2) {//左上
            [UIView animateWithDuration:0.2 animations:^{
                self.fpsLabel.center = CGPointMake(0.85 * BALLW, 0.85 * BALLW);
            }];
            
        }else{//右上
            [UIView animateWithDuration:0.2 animations:^{
                self.fpsLabel.center = CGPointMake(0.15 * BALLW, 0.85 * BALLW);
            }];
        }
        
    }else{//位于坐标系下半部分
        if (self.window.center.x <= TK_kscreenW/2) {//左下
            [UIView animateWithDuration:0.2 animations:^{
                self.fpsLabel.center = CGPointMake(0.85 * BALLW, 0.15 * BALLW);
            }];

        }else{//右下
            [UIView animateWithDuration:0.2 animations:^{
                self.fpsLabel.center = CGPointMake(0.15 * BALLW, 0.15 * BALLW);
            }];
        }
        
    }
    
}

@end
