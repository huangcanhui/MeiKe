//
//  RCDRCIMDataSource.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "RCDRCIMDataSource.h"
#import "RCDUserInfoManager.h"
#import "RCDHttpTool.h"
#import "RCDDataBaseManager.h"

@implementation RCDRCIMDataSource

+ (RCDRCIMDataSource *)shareInstance
{
    static RCDRCIMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)syncFriendList:(NSString *)userId complete:(void (^)(NSMutableArray *))completion
{

}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    RCUserInfo *user = [RCUserInfo new];
    if (userId == nil || [userId length] == 0) {
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return;
    }
    
    //调用自己的服务器接口根据userID异步请求数据
    if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        [[RCDUserInfoManager shareInstance] getUserInfo:userId completion:^(RCUserInfo *user) {
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
            completion(user);
        }];
    } else {
        [[RCDUserInfoManager shareInstance] getUserInfo:userId completion:^(RCUserInfo *user) {
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
            completion(user);
        }];
    }
    return;
}

- (NSArray *)getAllUserInfo:(void (^)(void))completion
{
    return [[RCDDataBaseManager shareInstance] getAllUserInfo];
}

- (NSArray *)getAllFriends:(void (^)(void))completion
{
    return [[RCDDataBaseManager shareInstance] getAllFriends];
}

@end
