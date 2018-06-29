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

- (void)start;

- (void)stop;
@end
