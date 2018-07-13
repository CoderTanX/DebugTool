//
//  ViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/6/29.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "ViewController.h"
#import "TKWindow.h"
#import "TKDebugTool.h"
#import "SDWebImageManager.h"
#import "NSDate+Additions.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://httpbin.org/get"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", response);
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    [task resume];

//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525346881086&di=b234c66c82427034962131d20e9f6b56&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F011cf15548caf50000019ae9c5c728.jpg%402o.jpg"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        NSLog(@"=======图片下载complete");
//    }];
    NSLog(@"%@", [NSDate systemTime]);
}
- (IBAction)bntClick {
    [TKDebugTool.sharedInstance stop];
}

@end
