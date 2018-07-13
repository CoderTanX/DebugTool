//
//  TKNetworkDetailViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/11.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKNetworkDetailViewController.h"
#import "TKNetworkModel.h"
#import "TKNetworkDetailViewCell.h"
#import "MJExtension.h"
#import "TKNetworkDetailImageCell.h"
static NSString *const kNetworkDetailViewCellID = @"kNetworkDetailViewCellID";
static NSString *const kNetworkDetailImageCellID = @"kNetworkDetailImageCellID";
@interface TKNetworkDetailViewController ()
@property (nonatomic, strong) NSArray<NSDictionary *> *dataArray;
@end

@implementation TKNetworkDetailViewController

- (NSArray<NSDictionary *> *)dataArray{
    if (!_dataArray){
        _dataArray = @[@{@"url": _networkModel.url},
                       @{@"method": _networkModel.method},
                       @{@"mimeType": _networkModel.mimeType},
                       @{@"statusCode": _networkModel.statusCode},
                       @{@"responseBody": [self prettyJSONStringFromStr: _networkModel.responseBody]},
                       @{@"requestBody": _networkModel.requestBody},
                       @{@"headerFields": _networkModel.headerFields},
                       @{@"errorDes": _networkModel.errorDes},
                       @{@"startDate": _networkModel.startDate},
                       @{@"totalDuration": _networkModel.totalDuration}];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self.tableView registerClass:[TKNetworkDetailViewCell class] forCellReuseIdentifier:kNetworkDetailViewCellID];
    if (self.networkModel.isImage) {
        [self.tableView registerClass:[TKNetworkDetailImageCell class] forCellReuseIdentifier:kNetworkDetailImageCellID];
    }
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.dataArray[indexPath.row] allKeys].firstObject;
    if (self.networkModel.isImage && [title isEqualToString:@"responseBody"]) {
        TKNetworkDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkDetailImageCellID];
        cell.titleLabel.text = title;
        cell.url = self.networkModel.url;
        return cell;
    }else{
        TKNetworkDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkDetailViewCellID];
        cell.titleLabel.text = title;
        cell.contentLabel.text = [self.dataArray[indexPath.row] allValues].firstObject;
        return cell;
    }
}


- (NSString *)prettyJSONStringFromStr:(NSString *)str{
    NSString *prettyString = str;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[str mj_JSONData] options:0 error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        prettyString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        prettyString = [prettyString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    
    return prettyString;
}


@end
