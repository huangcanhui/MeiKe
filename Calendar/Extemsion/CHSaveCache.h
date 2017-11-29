//
//  CHSaveCache.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHSaveCache : NSObject
/**
 * 获取缓存路径
 */
+ (NSString *)getCachePath;

/**
 * 计算目录大小
 */
+ (CGFloat)floderSizeAtPath:(NSString *)path;

/**
 * 根据路径删除文件
 */
+ (void)cleanCaches:(NSString *)path;
@end
