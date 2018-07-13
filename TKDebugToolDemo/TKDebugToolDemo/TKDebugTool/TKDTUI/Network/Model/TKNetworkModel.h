//
//  TKNetworkModel.h
//  CustomProtocolDemo
//
//  Created by usee on 2018/7/10.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKNetworkModel : NSObject
///索引
@property (nonatomic, copy) NSString  *ID;
///请求的url
@property (nonatomic, copy) NSString  *url;
///请求的方式
@property (nonatomic , copy) NSString *method;
///请求的类型
@property (nonatomic , copy) NSString *mimeType;
///请求的状态码
@property (nonatomic , copy) NSString *statusCode;
///返回的json
@property (nonatomic , copy) NSString *responseBody;
///请求体
@property (nonatomic , copy) NSString *requestBody;
///请求头
@property (nonatomic , copy) NSString *headerFields;
///请求的错误
@property (nonatomic , copy) NSString *errorDes;
///请求开始时间
@property (nonatomic, copy) NSString  *startDate;
///总时间
@property (nonatomic, copy) NSString  *totalDuration;
///是否是图片
@property (nonatomic , assign) BOOL    isImage;


@end
