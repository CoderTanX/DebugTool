//
//  TKCrashHelper.h
//  CatchCrashDemo
//
//  Created by usee on 2018/7/16.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKCrashHelper : NSObject
/**
 注册捕获异常
 */
+ (void)registerCatchCrash;
/**
 注销捕获异常
 */
+ (void)unregisterCatchCrash;
@end
