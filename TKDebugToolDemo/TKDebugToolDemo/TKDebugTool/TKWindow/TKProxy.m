//
//  TKProxy.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/2.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKProxy.h"

@implementation TKProxy

+ (instancetype)initWithTarget:(id)target{
    TKProxy *proxy = [self alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}



@end
