//
//  CHTime.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHTime : NSObject
/**
 * 获取当前时间
 */
+ (NSString *)getCurrentTimes;
/**
 * 获取时间戳(以秒为单位)
 */
+(NSString *)getNowTimeTimestamp2;
/**
 * 获取时间戳(以毫秒为单位)
 */
+(NSString *)getNowTimeTimestamp3;

@end