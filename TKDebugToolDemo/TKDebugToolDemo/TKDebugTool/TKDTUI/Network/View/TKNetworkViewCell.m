//
//  TKNetworkViewCell.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/11.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKNetworkViewCell.h"
#import "Masonry.h"
@implementation TKNetworkViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.baseURLLabel = [[UILabel alloc] init];
    self.baseURLLabel.font = [UIFont systemFontOfSize:15];
    self.baseURLLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.baseURLLabel];
    [self.baseURLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    self.pathLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pathLabel.font = [UIFont systemFontOfSize:13];
    self.pathLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.pathLabel];
    [self.pathLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];

}

@end
