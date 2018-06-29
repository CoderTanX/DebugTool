//
//  NSObject+Extension.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>
@implementation UIViewController (Extension)

+ (void)load{
    Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod(self, @selector(tk_dealloc));
    method_exchangeImplementations(method1, method2);
}

-(void)tk_dealloc{
    NSLog(@"%@-dealloc", self);
    [self tk_dealloc];
}

@end
