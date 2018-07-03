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
#import "TKProxy.h"
#import <mach/mach.h>
#import "TKTimer.h"
#define BALLW 80
@interface TKWindowViewController ()
@property (nonatomic, assign) CGPoint previousPoint;
@property (nonatomic, weak) UILabel *fpsLabel;
@property (nonatomic, weak) UILabel *cpuLabel;
@property (nonatomic, weak) UILabel *memoryLabel;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CFTimeInterval lastTimeStamp;
@property (nonatomic, assign) NSUInteger countPerFrame;
@property (nonatomic, copy) NSString *cpuTimerId;
@property (nonatomic, copy) NSString *memoryTimerId;
@end

@implementation TKWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置界面
    [self setupUI];
    //设置手势
    [self setupGestureRecognizer];
    //监听fps
    [self setupLink];
    //监听cpu
    [self setupCPU];
    //监听内存
    [self setupMemory];
}

/**
 设置UI界面
 */
- (void)setupUI{
    self.view.frame = CGRectMake(0, 0, BALLW, BALLW);
    //底部视图
    UIView *sBallView = [[UIView alloc] initWithFrame:self.view.bounds];
    sBallView.backgroundColor = [UIColor colorWithRed:0.30f green:0.69f blue:0.99f alpha:1.00f];
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
        make.centerY.equalTo(sBallView);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
    }];
    
    //显示内存使用
    UILabel *memoryLabel = [[UILabel alloc] init];
    memoryLabel.textColor = [UIColor whiteColor];
    memoryLabel.text = @"loading";
    memoryLabel.font = [UIFont systemFontOfSize:12];
    [sBallView addSubview:memoryLabel];
    [memoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sBallView);
        make.bottom.equalTo(lineView.mas_top).offset(-3);
    }];
    self.memoryLabel = memoryLabel;
    //显示cpu使用
    UILabel *cpuLabel = [[UILabel alloc] init];
    cpuLabel.textColor = [UIColor whiteColor];
    cpuLabel.text = @"loading";
    cpuLabel.font = [UIFont systemFontOfSize:12];
    [sBallView addSubview:cpuLabel];
    [cpuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sBallView);
        make.top.equalTo(lineView.mas_bottom).offset(3);
    }];
    self.cpuLabel = cpuLabel;
    
    //显示fps
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    fpsLabel.backgroundColor = [UIColor colorWithRed:0.30f green:0.69f blue:0.99f alpha:1.00f];
    fpsLabel.text = @"60";
    fpsLabel.font = [UIFont systemFontOfSize:10];
    fpsLabel.textColor = [UIColor whiteColor];
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    fpsLabel.layer.cornerRadius = 10;
    fpsLabel.layer.masksToBounds = YES;
    fpsLabel.center = CGPointMake(0.85 * BALLW, 0.85 * BALLW);
    [sBallView addSubview:fpsLabel];
    self.fpsLabel = fpsLabel;
}


/**
 监听fps
 */
- (void)setupLink{
    self.link = [CADisplayLink displayLinkWithTarget:[TKProxy initWithTarget:self] selector:@selector(invoke:)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invoke:(CADisplayLink *)link{
    if (self.lastTimeStamp == 0) {
        self.lastTimeStamp = link.timestamp;
        return;
    }
    self.countPerFrame++;
    NSTimeInterval interval = link.timestamp - self.lastTimeStamp;
    if (interval < 1) {
        return;
    }
    self.lastTimeStamp = link.timestamp;
    CGFloat fps = self.countPerFrame / interval;
    self.countPerFrame = 0;
    self.fpsLabel.text = [NSString stringWithFormat:@"%.f", fps];
    
}

/**
 监听cpu
 */
- (void)setupCPU{
    __weak typeof(self) weakSelf = self;
     self.cpuTimerId = [TKTimer execTask:^{
         dispatch_main_async_safe((^{
             weakSelf.cpuLabel.text = [NSString stringWithFormat:@"CPU:%.1f%%", [weakSelf GetCpuUsage]];
         }));
    } start:0 interval:1 repeats:YES asyn:YES];
}

/**
 监听内存
 */
- (void)setupMemory{
    __weak typeof(self) weakSelf = self;
    self.memoryTimerId = [TKTimer execTask:^{
        dispatch_main_async_safe((^{
            weakSelf.memoryLabel.text = [NSString stringWithFormat:@"%.1fMB", [weakSelf GetCurrentTaskUsedMemory]];
        }));
    } start:0 interval:1 repeats:YES asyn:YES];
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
//获取cpu
- (CGFloat)GetCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}
//获取内存
- (CGFloat)GetCurrentTaskUsedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if(kernReturn != KERN_SUCCESS) {
        return -1;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (void)dealloc{
    [self.link invalidate];
    [TKTimer stopTimerId:self.cpuTimerId];
    [TKTimer stopTimerId:self.memoryTimerId];
}

@end
