//
//  UIWindow+Extension.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/3.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TKDebugTool.h"

@implementation UIWindow (Extension)

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event{
    TKDebugTool.sharedInstance.isMonitor ? [TKDebugTool.sharedInstance stop] : [TKDebugTool.sharedInstance start];
}

@end
