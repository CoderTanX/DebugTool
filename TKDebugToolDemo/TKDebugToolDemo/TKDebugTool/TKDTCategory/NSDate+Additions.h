//
//  NSDate+Additions.h
//  SixGod
//
//  Created by 谭安溪 on 16/3/1.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

@property (nonatomic,copy,readonly) NSString *timestamp;///<时间戳
/**
 *  当前时间
 */
+ (NSDate *)systemTime;
/**
 *  时间戳转化成date
 */
+ (NSDate *)dateFromTimestamp:(id)timestamp;

/**
 *  格式化时间
 *
 *  @param format e.g. @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 格式化后的字符串
 */
- (NSString *)stringWithFormat:(NSString *)format;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;



/**
 *  星期几
 *
 *  @return e.g. 星期日
 */
- (NSString *)weekday;

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)

@property (nonatomic, readonly) BOOL isToday;///<是否是今天

///给指定的日期获取对应月的天数
+ (NSInteger)getDaysWithDate: (NSDate*)date;
/**
 *获取指定年月的第一天是周几
 */
+ (NSInteger)getFirstWeekdayWithYear:(NSInteger)year month:(NSInteger)month;
/**
 *获取指定年月有多少天
 */
+ (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month;
@end
