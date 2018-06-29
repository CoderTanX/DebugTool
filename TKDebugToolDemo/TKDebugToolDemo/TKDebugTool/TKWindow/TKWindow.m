//
//  TKWindow.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKWindow.h"
#import "TKWindowViewController.h"
@implementation TKWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.hidden = NO;
        TKWindowViewController *windowVc = [[TKWindowViewController alloc] init];
        windowVc.window = self;
        self.rootViewController = windowVc;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}


@end
