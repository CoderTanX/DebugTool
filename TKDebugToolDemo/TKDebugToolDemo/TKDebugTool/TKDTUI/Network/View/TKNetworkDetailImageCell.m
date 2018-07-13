//
//  TKNetworkDetailImageCell.m
//  TKDebugToolDemo
//
//  Created by usee on 2018/7/13.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKNetworkDetailImageCell.h"
#import "Masonry.h"
#import "TKDebugToolMacro.h"
#import "SDImageCache.h"
@interface TKNetworkDetailImageCell()
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation TKNetworkDetailImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setUrl:(NSString *)url{
    _url = url;
    UIImage *image = [[SDImageCache new] imageFromCacheForKey:url];
    CGSize size = image.size;
    if (size.width > TK_kscreenW) {
        size.width = TK_kscreenW;
        size.height = (image.size.height/image.size.width) * TK_kscreenW;
    }
    self.imageV.image = image;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageV];
    
//    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
//        make.bottom.equalTo(self.contentView).offset(-10);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(100);
//    }];
    
}

@end
