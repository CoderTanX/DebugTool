//
//  TKCustomURLProtocol.m
//  CustomProtocolDemo
//
//  Created by usee on 2018/7/6.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKCustomURLProtocol.h"
#import "TKNetworkModel.h"
#import "MJExtension.h"
#import "NSDate+Additions.h"
#import "TKStorageManager.h"
static  NSString *const identifier = @"TKCustomURLProtocolIdentifier";
@interface TKCustomURLProtocol() <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSDate *startDate;
@end
@implementation TKCustomURLProtocol

- (NSMutableData *)data{
    if (!_data) {
        _data = [NSMutableData data];
    }
    return _data;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    //根据这个标识，防止重复调用。
    if ([self propertyForKey:identifier inRequest:request]) {
        return NO;
    }
    NSString *scheme = [[request URL] scheme];
    //只监听http和https请求
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    //直接返回就可以
    return request;
}

- (void)startLoading{
    //设置标识
    NSMutableURLRequest *mRequest = [self.request mutableCopy];
    [self.class setProperty:@(YES) forKey:identifier inRequest:mRequest];
    //开始时间
    self.startDate = [NSDate systemTime];
    //开始请求
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.dataTask = [session dataTaskWithRequest:mRequest];
    [self.dataTask resume];
    
}

- (void)stopLoading{
    //取消dataTask
    [self.dataTask cancel];
    self.dataTask = nil;
    NSLog(@"%s", __func__);
    //给模型赋值
    TKNetworkModel *model = [[TKNetworkModel alloc] init];
    model.url = self.request.URL.absoluteString ? : @"";
    model.method = self.request.HTTPMethod ? : @"";
    model.mimeType = self.response.MIMEType ? : @"";
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    model.statusCode = [NSString stringWithFormat:@"%ld", httpResponse.statusCode] ? : @"";
    model.responseBody = [self.data mj_JSONString] ? : @"";
    model.requestBody = [self.request.HTTPBody mj_JSONString] ? : @"";
    model.headerFields = [self.request.allHTTPHeaderFields mj_JSONString] ? : @"";
    model.errorDes = self.error.description ? : @"";
    model.startDate = [self.startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] ? : @"";
    model.totalDuration = [NSString stringWithFormat:@"%lfs", [[NSDate systemTime] timeIntervalSinceDate:self.startDate]] ? : @"";
    if (self.response.MIMEType) {
        model.isImage = [self.response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    }
    NSString *absoluteString = self.request.URL.absoluteString.lowercaseString;
    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"] || [absoluteString hasSuffix:@".gif"]) {
        model.isImage = YES;
    }
    //存储起来
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [[TKStorageManager sharedInstance] saveNetworkModel:model];
    });
}



#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }else if ( [[error domain] isEqual:NSURLErrorDomain] && ([error code] == NSURLErrorCancelled) ) {
        // Do nothing.  This happens in two cases:
        //
        // o during a redirect, in which case the redirect code has already told the client about
        //   the failure
        //
        // o if the request is cancelled by a call to -stopLoading, in which case the client doesn't
        //   want to know about the failure
    }else{
        [self.client URLProtocolDidFinishLoading:self];
    }
    self.error = error;
    //必须调用，否则无法释放
    [session finishTasksAndInvalidate];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    self.response = response;
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    completionHandler(request);
}


#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    self.response = response;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}

@end
