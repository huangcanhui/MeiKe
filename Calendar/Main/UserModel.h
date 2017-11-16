//
//  UserModel.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mobile.h"

@interface UserModel : NSObject

@property (nonatomic, strong)User *user;
@property (nonatomic, strong)UserInfo *userInfo;

+ (instancetype)defaultInstance;
/**
 * 检测用户是否登录
 */
+ (BOOL)onLine;

/**
 * 获取用户信息
 */
- (void)info;

/**
 * 退出登录
 */
- (void)logout;

/**
 * token过期被踢出登录
 */
- (void)kickout;
/**
 * 清除缓存
 */
- (void)clearCache;

@end
