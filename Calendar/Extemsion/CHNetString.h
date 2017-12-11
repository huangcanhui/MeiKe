//
//  CHNetString.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/8.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHNetString : NSObject
/**
 * 拼接图片的正确地址
 */
+ (NSString *)isValueInNetAddress:(NSString *)obj;
///**
// * 获取七牛的uptoken
// */
//+ (NSString *)getQNUptoken;

/**
 * 循环赛，返回的组数
 */
+ (NSString *)circleRace:(NSString *)membercount;

/**
 * 循环赛，返回的场次数
 */
+ (NSString *)circleTeamRaceCount:(NSString *)membercount;

/**
 * 淘汰赛，返回的组数
 */
+ (NSString *)knockOutRace:(NSString *)membercount;
@end
