//
//  TKStorageManager.h
//  CustomProtocolDemo
//
//  Created by usee on 2018/7/10.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKDebugToolMacro.h"

@class TKNetworkModel;
@interface TKStorageManager : NSObject

TK_SINGLETON_DEF(TKStorageManager)

- (void)saveNetworkModel:(TKNetworkModel *)model;

- (NSArray<TKNetworkModel*>*)getNetworkModelsWithID:(NSInteger)ID isNew:(BOOL)isNew;

@end
