//
//  TKDebugTool.h
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKDebugToolMacro.h"
@interface TKDebugTool : NSObject
//单例
TK_SINGLETON_DEF(TKDebugTool)
////是否已经开始
@property(nonatomic, assign, readonly, getter=isMonitoring) BOOL monitoring;

- (void)start;

- (void)stop;

//忽略监听的url
@property (nonatomic, strong) NSMutableArray *ignorePaths;

@end
