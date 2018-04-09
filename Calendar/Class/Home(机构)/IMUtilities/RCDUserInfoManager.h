//
//  RCDUserInfoManager.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUserInfo.h"

@interface RCDUserInfoManager : NSObject

+ (RCDUserInfoManager *)shareInstance;

/**
 * 通过自己ID获取自己的信息
 */
- (void)getUserInfo:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;
/**
 * 通过好友ID获取好友的信息
 */
- (void)getFriendInfo:(NSString *)friendID completion:(void (^)(RCUserInfo *))completion;
/**
 * 通过好友ID从数据库中获取好友的信息
 */
- (RCUserInfo *)getFriendInFromDB:(NSString *)friendID;
/**
 * 如果有好友备注，则显示备注
 */
- (NSArray *)getFriendInfoList:(NSArray *)friendList;
/**
 * 通过userID设置默认的用户信息
 */
- (RCUserInfo *)generateDefaultUserInfo:(NSString *)userId;
@end
