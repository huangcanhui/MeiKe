//
//  RCDDataBaseManager.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUserInfo.h"

@interface RCDDataBaseManager : NSObject

+ (RCDDataBaseManager *)shareInstance;

- (void)closeDBForDisconnect;

/**
 * 存储用户信息
 */
- (void)insertUserToDB:(RCUserInfo *)user;

- (void)insertUserListToDB:(NSMutableArray *)userList complete:(void (^)(BOOL))result;

/**
 * 从表中获取用户信息
 */
- (RCUserInfo *)getUserByUserId:(NSString *)userId;

/**
 * 从表中获取所有的用户信息
 */
- (NSArray *)getAllUserInfo;

/**
 * 存储好友信息
 */
- (void)insertFriendToDB:(RCUserInfo *)friendInfo;

- (void)insertFriendListToDB:(NSMutableArray *)FriendList complete:(void (^)(BOOL))result;

/**
 * 从表中获取所有的好友信息
 */
- (NSArray *)getAllFriends;

/**
 * 从表中获取某个好友信息
 */
- (RCUserInfo *)getFriendInfo:(NSString *)friendId;

/**
 * 删除好友信息
 */
- (void)deleteFriendFromDB:(NSString *)userId;

/**
 * 清空好友缓存数据
 */
- (void)clearFriendsData;

@end
