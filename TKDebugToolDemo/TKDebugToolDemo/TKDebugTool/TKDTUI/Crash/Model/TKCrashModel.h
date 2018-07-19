//
//  TKCrashModel.h
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/17.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKCrashModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *callStackSymbols;
@property (nonatomic, copy) NSString *date;
@end
