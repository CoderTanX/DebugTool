//
//  TKCrashListViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/17.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKCrashListViewController.h"
#import "TKCrashDetailViewController.h"
#import "TKStorageManager.h"
#import "TKCrashModel.h"


static NSString *const kCrashListCellID = @"kCrashListCellID";
@interface TKCrashListViewController ()
@property (nonatomic, strong) NSArray<TKCrashModel *> *crashModels;
@end

@implementation TKCrashListViewController

- (NSArray<TKCrashModel *> *)crashModels{
    if (!_crashModels) {
        _crashModels = [[TKStorageManager sharedInstance] getAllCrashModel];
    }
    return _crashModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Crash";
    //注册cell
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crashModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashListCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCrashListCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    TKCrashModel *model = self.crashModels[indexPath.row];
    cell.textLabel.text = model.reason;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = model.date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TKCrashDetailViewController *cdVc = [[TKCrashDetailViewController alloc] init];
    TKCrashModel *model = self.crashModels[indexPath.row];
    cdVc.crashModel = model;
    [self.navigationController pushViewController:cdVc animated:YES];
}

- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
