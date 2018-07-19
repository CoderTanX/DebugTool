//
//  TKCrashDetailViewController.h
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/17.
//  Copyright © 2018年 tax. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKCrashModel;
@interface TKCrashDetailViewController : UITableViewController
@property (nonatomic, strong) TKCrashModel *crashModel;
@end
