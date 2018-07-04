//
//  TKTimer.m
//  GCD定时器
//
//  Created by usee on 2018/6/25.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKTimer.h"

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphore_;
@implementation TKTimer

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats asyn:(BOOL)asyn{
    if (!task) return nil;
    dispatch_queue_t queue = asyn ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    //定时器唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    timers_[name] = timer;
    dispatch_semaphore_signal(semaphore_);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (!repeats) {
            [self stopTimerId:name];
        }
        task();
    });
    dispatch_resume(timer);
    return name;
}

+ (NSString *)execTarget:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats asyn:(BOOL)asyn{
    if (!target || !selector) {
        return nil;
    }
    
    return [self execTask:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selector];
#pragma clang diagnostic pop
    } start:start interval:interval repeats:repeats asyn:asyn];
}

+ (void)stopTimerId:(NSString *)timerId{
    if (timerId.length == 0) return;
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[timerId];
    dispatch_semaphore_signal(semaphore_);
    if (!timer) return;
    dispatch_source_cancel(timer);
    [timers_ removeObjectForKey:timerId];
}

@end
