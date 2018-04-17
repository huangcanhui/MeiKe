//
//  CHSepreatorString.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/17.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHSepreatorString : NSObject
/**
 * 这是一个字符串的分割方式
 * @params string 要分割的字符串
 * @params chactor 用何种方式进行分割
 */
+ (NSArray *)stringToSepreator:(NSString *)string withChactor:(NSString *)chactor;

@end
