//
//  CHSepreatorString.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/17.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSepreatorString.h"

@implementation CHSepreatorString

+ (NSArray *)stringToSepreator:(NSString *)string withChactor:(NSString *)chactor
{
    NSArray *array = [string componentsSeparatedByString:chactor];
    return array;
}

@end
