//
//  TKDebugTool.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKDebugTool.h"
#import "TKWindow.h"
#import "TKCustomURLProtocol.h"

@interface TKDebugTool()
@property (nonatomic, strong)TKWindow *window;
@end

@implementation TKDebugTool

TK_SINGLETON_IMP(TKDebugTool)

- (void)start{
    TKDebugTool.sharedInstance.window = [[TKWindow alloc] initWithFrame:CGRectMake(100, 300, BALLW, BALLW)];
    [NSURLProtocol registerClass:[TKCustomURLProtocol class]];
}

- (void)stop{
    self.window = nil;
    [NSURLProtocol unregisterClass:[TKCustomURLProtocol class]];
}

- (BOOL)isMonitor{
    return self.window != nil;
    
}


@end
