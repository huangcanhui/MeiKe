//
//  RCDHttpTool.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUserInfo.h"
#define RCDHTTPTOOL [RCDHttpTool shareInstance]

@interface RCDHttpTool : NSObject

+ (RCDHttpTool *)shareInstance;

/**
 * 获取个人信息
 */
- (void)getUserInfoByUserID:(NSString *)userID completion:(void (^)(RCUserInfo *user))completion;
/**
 * 获取个人头像地址
 */
- (void)setUserPortraitUri:(NSString *)portraitUri complete:(void (^)(BOOL))result;
/**
 * 获取用户的详细信息
 */
- (void)getFriendDetailsWithFriendId:(NSString *)friendId
                             success:(void (^)(RCUserInfo *user))success
                             failure:(void (^)(NSError *err))failure;
@end
