//
//  TKDebugTool.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKDebugTool.h"
#import "TKWindow.h"
#import "TKDTCustomURLProtocol.h"
#import "TKCrashHelper.h"

@interface TKDebugTool()
@property (nonatomic, strong)TKWindow *window;
@end

@implementation TKDebugTool

TK_SINGLETON_IMP(TKDebugTool)

- (NSMutableArray *)ignorePaths{
    if (!_ignorePaths) {
        _ignorePaths = [[NSMutableArray alloc] initWithObjects:@"msg/hasMsg",@"/expressNews/list", nil];
    }
    return _ignorePaths;
}

- (void)start{
    
    TKDebugTool.sharedInstance.window = [[TKWindow alloc] initWithFrame:CGRectMake(100, 300, BALLW, BALLW)];
    //注册URL监听
    [NSURLProtocol registerClass:[TKDTCustomURLProtocol class]];
    //注册捕获异常
    [TKCrashHelper registerCatchCrash];
}

- (void)stop{
    self.window = nil;
    //注销URL监听
    [NSURLProtocol unregisterClass:[TKDTCustomURLProtocol class]];
    //注销捕获异常
    [TKCrashHelper unregisterCatchCrash];
    
}

- (BOOL)isMonitoring{
    return self.window != nil;
    
}


@end
