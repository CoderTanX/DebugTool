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
    TKDebugTool.sharedInstance.isMonitoring ? [TKDebugTool.sharedInstance stop] : [TKDebugTool.sharedInstance start];
}

- (UIViewController*)topMostWindowController
{
    UIViewController *topController = [self rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}

- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}


@end
