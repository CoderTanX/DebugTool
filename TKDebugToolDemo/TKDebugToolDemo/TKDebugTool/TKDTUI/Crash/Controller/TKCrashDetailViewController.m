//
//  TKCrashDetailViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/17.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKCrashDetailViewController.h"
#import "TKCrashDetailViewCell.h"
#import "TKCrashModel.h"
static NSString *const kCrashDetailViewCellID = @"kCrashDetailViewCellID";
@interface TKCrashDetailViewController ()
@property (nonatomic, strong) NSArray<NSDictionary *> *dataArray;

@end

@implementation TKCrashDetailViewController

- (NSArray<NSDictionary *> *)dataArray{
    if (!_dataArray){
        _dataArray = @[@{@"name": _crashModel.name},
                       @{@"reason": _crashModel.reason},
                       @{@"callStackSymbols": _crashModel.callStackSymbols},
                       @{@"date": _crashModel.date}];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";
    [self.tableView registerClass:[TKCrashDetailViewCell class] forCellReuseIdentifier:kCrashDetailViewCellID];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKCrashDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashDetailViewCellID];
    cell.titleLabel.text = self.dataArray[indexPath.row].allKeys.firstObject;
    cell.contentLabel.text = self.dataArray[indexPath.row].allValues.firstObject;
    return cell;
}




@end
