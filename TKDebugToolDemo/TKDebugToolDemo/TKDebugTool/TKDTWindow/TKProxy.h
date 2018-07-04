//
//  TKProxy.h
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/2.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKProxy : NSProxy
+ (instancetype)initWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end
