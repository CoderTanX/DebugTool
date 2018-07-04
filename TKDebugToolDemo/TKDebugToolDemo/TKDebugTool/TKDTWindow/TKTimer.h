//
//  TKTimer.h
//  GCD定时器
//
//  Created by usee on 2018/6/25.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKTimer : NSObject

+ (NSString *)execTask:(void(^)(void))task
           start:(NSTimeInterval)start
        interval:(NSTimeInterval)interval
         repeats: (BOOL)repeats
            asyn:(BOOL)asyn;
+ (NSString *)execTarget:(id)target
                selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats: (BOOL)repeats
                  asyn:(BOOL)asyn;
+ (void)stopTimerId:(NSString *)timerId;

@end
