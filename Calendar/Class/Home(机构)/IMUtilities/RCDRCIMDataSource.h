//
//  RCDRCIMDataSource.h
//  Calendar
//   实现融云的数据源
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#define RCDDataSource [RCDRCIMDataSource shareInstance]

@interface RCDRCIMDataSource : NSObject <RCIMUserInfoDataSource>

+ (RCDRCIMDataSource *)shareInstance;

/**
 * 从服务器同步好友列表
 */
- (void)syncFriendList:(NSString *)userId complete:(void (^)(NSMutableArray *friends))completion;

/**
 * 获取所有的用户信息
 */
- (NSArray *)getAllUserInfo:(void (^)(void))completion;

/*
 * 获取所有好友信息
 */
- (NSArray *)getAllFriends:(void (^)(void))completion;
@end
