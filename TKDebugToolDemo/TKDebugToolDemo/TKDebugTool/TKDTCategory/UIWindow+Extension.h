//
//  UIWindow+Extension.h
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/3.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *topMostWindowController;

/**
 Returns the topViewController in stack of topMostWindowController.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *currentViewController;

@end
