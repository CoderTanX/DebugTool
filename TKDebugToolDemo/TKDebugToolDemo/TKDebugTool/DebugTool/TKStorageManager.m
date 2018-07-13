//
//  TKStorageManager.m
//  CustomProtocolDemo
//
//  Created by usee on 2018/7/10.
//  Copyright © 2018年 tax. All rights reserved.
//

#import "TKStorageManager.h"
#import "TKNetworkModel.h"
#import "FMDB.h"

static NSString *const kScreateTKNetworkTabelsql = @"CREATE TABLE if NOT EXISTS TKNetworkTabel(id integer PRIMARY KEY AUTOINCREMENT NOT NULL, url text, method VARCHAR(16), mimeType VARCHAR(128), statusCode VARCHAR(8), responseBody text, requestBody text, headerFields text, errorDes text, startDate VARCHAR(16), totalDuration VARCHAR(16), isImage TINYINT);";

static NSString *const TKNetworkTabel = @"TKNetworkTabel";

@interface TKStorageManager()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end
@implementation TKStorageManager

TK_SINGLETON_IMP(TKStorageManager)

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL ret = [TKStorageManager.sharedInstance initDataBase];
        if (!ret) NSLog(@"数据库创建失败");
    });
}

- (BOOL)initDataBase{
    _queue = [FMDatabaseQueue databaseQueueWithPath:[self getTKDebugDBFilePath]];
    __block BOOL ret = NO;
    //创建表
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        ret = [db executeUpdate: kScreateTKNetworkTabelsql];
    }];
    return ret;
}

- (NSString *)getTKDebugDBFilePath{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES).firstObject;
    NSString *folderPath = [documentPath stringByAppendingPathComponent:@"TKDebug"];
    //创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:@"TKDebug.db"];
    
    return filePath;
    
}

- (void)saveNetworkModel:(TKNetworkModel *)model{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getTKDebugDBFilePath]];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSLog(@"%@", [NSThread currentThread]);
        BOOL ret = [db executeUpdate:@"insert into TKNetworkTabel (url, method, mimeType, statusCode, responseBody, requestBody, headerFields, errorDes, startDate, totalDuration, isImage) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", model.url, model.method, model.mimeType, model.statusCode, model.responseBody, model.requestBody, model.headerFields, model.errorDes, model.startDate, model.totalDuration, @(model.isImage)];
        if (!ret) NSLog(@"TKNetworkModel插入失败");
    }];
}

- (NSArray<TKNetworkModel*>*)getNetworkModelsWithID:(NSInteger)ID isNew:(BOOL)isNew{
    NSString *sql = @"";
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger length = pageSize;
    if (isNew){//是请求新数据
        if (ID > 0){
            sql = [NSString stringWithFormat:@"select *from %@ where id > %ld ORDER BY id DESC;", TKNetworkTabel, ID];
        }else{
            sql = [NSString stringWithFormat:@"select *from %@ ORDER BY id DESC limit %ld;", TKNetworkTabel, length];
        }
    }else{//加载更多数据
        sql = [NSString stringWithFormat:@"select *from %@ where id < %ld ORDER BY id DESC limit %ld;", TKNetworkTabel, ID, length];
    }

//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getTKDebugDBFilePath]];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            TKNetworkModel *model = [[TKNetworkModel alloc] init];
            model.ID =  [resultSet stringForColumn:@"id"];
            model.url = [resultSet stringForColumn:@"url"];
            model.method = [resultSet stringForColumn:@"method"];
            model.mimeType = [resultSet stringForColumn:@"mimeType"];
            model.statusCode = [resultSet stringForColumn:@"statusCode"];
            model.responseBody = [resultSet stringForColumn:@"responseBody"];
            model.requestBody = [resultSet stringForColumn:@"requestBody"];
            model.headerFields = [resultSet stringForColumn:@"headerFields"];
            model.errorDes = [resultSet stringForColumn:@"errorDes"];
            model.startDate = [resultSet stringForColumn:@"startDate"];
            model.totalDuration = [resultSet stringForColumn:@"totalDuration"];
            model.isImage  = [[resultSet stringForColumn:@"isImage"] boolValue];
            [tempArray addObject:model];
        }
    }];
    return [tempArray copy];
}



@end
