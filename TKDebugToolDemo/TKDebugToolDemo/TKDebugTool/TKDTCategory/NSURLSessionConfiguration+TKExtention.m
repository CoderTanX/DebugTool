//
//  NSURLSessionConfiguration+TKExtention.m
//  CustomProtocolDemo
//
//  Created by usee on 2018/7/11.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "NSURLSessionConfiguration+TKExtention.h"
#import <objc/runtime.h>
#import "TKDTCustomURLProtocol.h"
@implementation NSURLSessionConfiguration (TKExtention)

+ (void)load{
    Method methoh1 = class_getClassMethod([self class], @selector(defaultSessionConfiguration));
    Method methoh2 = class_getClassMethod([self class], @selector(tk_defaultSessionConfiguration));
    method_exchangeImplementations(methoh1, methoh2);
    
    Method methoh3 = class_getClassMethod([self class], @selector(ephemeralSessionConfiguration));
    Method methoh4 = class_getClassMethod([self class], @selector(tk_ephemeralSessionConfiguration));
    method_exchangeImplementations(methoh3, methoh4);

}

+ (NSURLSessionConfiguration *)tk_defaultSessionConfiguration{
    NSURLSessionConfiguration *config = [self tk_defaultSessionConfiguration];
    NSMutableArray *protocols = [config.protocolClasses mutableCopy];
    if (![protocols containsObject:[TKDTCustomURLProtocol class]]){
        [protocols insertObject:[TKDTCustomURLProtocol class] atIndex:0];
    }
    config.protocolClasses = protocols;
    return config;
}

+ (NSURLSessionConfiguration *)tk_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *config = [self tk_ephemeralSessionConfiguration];
    NSMutableArray *protocols = [config.protocolClasses mutableCopy];
    if (![protocols containsObject:[TKDTCustomURLProtocol class]]){
        [protocols insertObject:[TKDTCustomURLProtocol class] atIndex:0];
    }
    config.protocolClasses = protocols;
    return config;
}

@end
