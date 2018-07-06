//
//  TKDTDeviceViewController.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/4.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKDTDeviceViewController.h"
#import "TKDebugToolMacro.h"
#import <sys/sysctl.h>
#import <mach-o/arch.h>


@interface TKDTDeviceViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TKDTDeviceViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSArray *appArray = @[@{@"APP名称": infoDict[@"CFBundleName"]},
                              @{@"APPID": infoDict[@"CFBundleIdentifier"]},
                              @{@"APP版本": [NSString stringWithFormat:@"%@(%@)",  infoDict[@"CFBundleShortVersionString"],infoDict[@"CFBundleVersion"]]}];
        [_dataArray addObject:appArray];
        UIDevice *device = [UIDevice currentDevice];
        NSArray *deviceArray = @[@{@"机型": [self getCurrentDeviceModel]},
                                 @{@"名称": device.name},
                                 @{@"版本": device.systemVersion},
                                 @{@"分辨率": [NSString stringWithFormat:@"%ld * %ld",(long)(TK_kscreenW * [UIScreen mainScreen].scale),(long)(TK_kscreenH * [UIScreen mainScreen].scale)]},
                                 @{@"语言": [NSLocale preferredLanguages].firstObject},
                                 @{@"CPU架构": [NSString stringWithUTF8String:NXGetLocalArchInfo()->description]},
                                 @{@"硬盘": [NSString stringWithFormat:@"%@ / %@", [NSByteCountFormatter stringFromByteCount:[self getFreeDisk] countStyle:NSByteCountFormatterCountStyleFile],[NSByteCountFormatter stringFromByteCount:[self getTotalDisk] countStyle:NSByteCountFormatterCountStyleFile]]}];
        
        [_dataArray addObject:deviceArray];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Device";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.tableView.tableFooterView = [UIView new];
}

- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict.allKeys.firstObject;
    cell.detailTextLabel.text = dict.allValues.firstObject;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"APP信息";
    }
    return @"设备信息";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}


- (NSString *)getCurrentDeviceModel
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) {
        
        if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        
    } else if ([platform hasPrefix:@"iPad"]) {
        
        if ([platform isEqualToString:@"iPad6,8"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,7"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,4"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,3"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad5,4"])    return @"iPad Air2";
        if ([platform isEqualToString:@"iPad5,3"])    return @"iPad Air2";
        if ([platform isEqualToString:@"iPad5,2"])    return @"iPad Mini4";
        if ([platform isEqualToString:@"iPad5,1"])    return @"iPad Mini4";
        if ([platform isEqualToString:@"iPad4,9"])    return @"iPad Mini3";
        if ([platform isEqualToString:@"iPad4,8"])    return @"iPad Mini3";
        if ([platform isEqualToString:@"iPad4,7"])    return @"iPad Mini3";
        if ([platform isEqualToString:@"iPad4,6"])    return @"iPad Mini2";
        if ([platform isEqualToString:@"iPad4,5"])    return @"iPad Mini2";
        if ([platform isEqualToString:@"iPad4,4"])    return @"iPad Mini2";
        if ([platform isEqualToString:@"iPad4,3"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,2"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,1"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad3,6"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,5"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,4"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,3"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,2"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,1"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad2,7"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,6"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,5"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad1,1"])    return @"iPad 1";
        
    } else if ([platform hasPrefix:@"iPod"]) {
        if ([platform isEqualToString:@"iPod7,1"])    return @"iPod 6";
        if ([platform isEqualToString:@"iPod5,1"])    return @"iPod 5";
        if ([platform isEqualToString:@"iPod4,1"])    return @"iPod 4";
        if ([platform isEqualToString:@"iPod3,1"])    return @"iPod 3";
        if ([platform isEqualToString:@"iPod2,1"])    return @"iPod 2";
        if ([platform isEqualToString:@"iPod1,1"])    return @"iPod 1";
    } else {
        if ([platform isEqualToString:@"i386"])       return @"simulator";
        if ([platform isEqualToString:@"x86_64"])     return @"simulator";
    }
    return @"unknown";
}
- (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

#pragma mark - Disk
- (unsigned long long)getTotalDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
}

- (unsigned long long)getFreeDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}

@end
