//
//  TKCrashHelper.m
//  CatchCrashDemo
//
//  Created by usee on 2018/7/16.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKCrashHelper.h"
#import <libkern/OSAtomic.h>
#include <execinfo.h>
#import "TKCrashModel.h"
#import "TKStorageManager.h"
#import "NSDate+Additions.h"
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

@implementation TKCrashHelper

/**
 注册捕获异常
 */
+ (void)registerCatchCrash{
    NSSetUncaughtExceptionHandler(TKNSUncaughtExceptionHandler);
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, TKHandleException);
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, TKHandleException);
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, TKHandleException);
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, TKHandleException);
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, TKHandleException);
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, TKHandleException);
    
}
/**
 注销捕获异常
 */
+ (void)unregisterCatchCrash{
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}


void TKNSUncaughtExceptionHandler(NSException *exception){
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    TKCrashModel *model = [[TKCrashModel alloc] init];
    model.name = exception.name;
    model.reason = exception.reason;
    NSMutableString *mutStr = [[NSMutableString alloc] init];
    NSArray *array = [exception callStackSymbols];
    for (int i = 0; i < array.count; i++) {
        NSString *symbol = array[i];
        if (i == array.count - 1) {
            [mutStr appendString:symbol];
        }else{
            [mutStr appendFormat:@"%@\n\n",symbol];
        }
    }
    model.callStackSymbols = mutStr;
    model.date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [[TKStorageManager sharedInstance] saveCrashModel:model];
}

//处理signal报错
void TKHandleException(int signal){
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSString *reason = @"";
    switch (signal) {
        case SIGABRT:
            reason = @"由于abort()函数调用发生的程序中止信号";
            break;
        case SIGILL:
            reason = @"由于非法指令产生的程序中止信号";
            break;
        case SIGSEGV:
            reason = @"由于无效内存的引用导致的程序中止信号";
            break;
        case SIGFPE:
            reason = @"由于浮点数异常导致的程序中止信号";
            break;
        case SIGBUS:
            reason = @"由于内存地址未对齐导致的程序中止信号";
            break;
        case SIGPIPE:
            reason = @"程序通过端口发送消息失败导致的程序中止信号";
            break;
        default:
            break;
    }
    
    TKCrashModel *model = [[TKCrashModel alloc] init];
    model.name = UncaughtExceptionHandlerSignalExceptionName;
    model.reason = reason;
    NSMutableString *mutStr = [[NSMutableString alloc] init];
    NSArray *array = [TKCrashHelper backtrace];
    for (int i = 0; i < array.count; i++) {
        NSString *symbol = array[i];
        if (i == array.count - 1) {
            [mutStr appendString:symbol];
        }else{
            [mutStr appendFormat:@"%@\n\n",symbol];
        }
    }
    model.date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[TKStorageManager sharedInstance] saveCrashModel:model];
    });
    
}
//获取调用堆栈
+ (NSArray *)backtrace {
    
    //指针列表
    void* callstack[128];
    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
    //128用来指定当前的buffer中可以保存多少个void*元素
    //返回值是实际获取的指针个数
    int frames = backtrace(callstack, 128);
    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组
    //返回一个指向字符串数组的指针
    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i ++) {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

@end
