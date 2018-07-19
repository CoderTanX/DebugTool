//
//  TKNetwrokListViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/11.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKNetwrokListViewController.h"
#import "TKStorageManager.h"
#import "TKNetworkModel.h"
#import "MJRefresh.h"
#import "TKNetworkViewCell.h"
#import "TKNetworkDetailViewController.h"
static NSString *const kNetworkViewCellID = @"kNetworkViewCellID";
@interface TKNetwrokListViewController ()
@property (nonatomic, strong) NSMutableArray *networkModels;

@end

@implementation TKNetwrokListViewController

- (NSMutableArray *)networkModels{
    if (!_networkModels) {
        _networkModels = [NSMutableArray array];
    }
    return _networkModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络请求";
    //注册cell
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    [self.tableView registerClass:[TKNetworkViewCell class] forCellReuseIdentifier:kNetworkViewCellID];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNewData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
    }];
    
    [weakSelf getNewData];

}

- (void)getNewData{
    NSInteger maxID = 0;
    if(self.networkModels.count > 0){
        maxID = [[self.networkModels.firstObject ID] integerValue];
    }
    NSMutableArray *tempArray = [[TKStorageManager.sharedInstance getNetworkModelsWithID:maxID isNew:YES] mutableCopy];
    if (tempArray.count < pageSize && maxID == 0){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    self.networkModels = [[tempArray arrayByAddingObjectsFromArray:self.networkModels] mutableCopy];
    [self.tableView reloadData];
}

- (void)getMoreData{
    NSInteger minID = [[self.networkModels.lastObject ID] integerValue];
    NSArray *tempArray = [TKStorageManager.sharedInstance getNetworkModelsWithID:minID isNew:NO];
    if (tempArray.count < pageSize){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
         [self.tableView.mj_footer endRefreshing];
    }
    [self.networkModels addObjectsFromArray:tempArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.networkModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKNetworkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkViewCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TKNetworkModel *networkModel = self.networkModels[indexPath.row];
    NSURL *url = [NSURL URLWithString:networkModel.url];
    cell.baseURLLabel.text = [NSString stringWithFormat:@"%@//%@", url.scheme, url.host];
    cell.pathLabel.text = url.path;
    cell.timeLabel.text = [networkModel.startDate componentsSeparatedByString:@" "].lastObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TKNetworkDetailViewController *detailVc = [[TKNetworkDetailViewController alloc] init];
    TKNetworkModel *networkModel = self.networkModels[indexPath.row];
    detailVc.networkModel = networkModel;
    [self.navigationController pushViewController:detailVc animated:YES];
}


- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
