//
//  RCDUserInfoManager.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "RCDUserInfoManager.h"
#import "RCDHttpTool.h"
#import "RCDDataBaseManager.h"

@implementation RCDUserInfoManager

+ (RCDUserInfoManager *)shareInstance
{
    static RCDUserInfoManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)getUserInfo:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    [RCDHTTPTOOL getUserInfoByUserID:userId completion:^(RCUserInfo *user) {
        if (user) {
            completion(user);
            return ;
        } else {
            user = [[RCDDataBaseManager shareInstance] getUserByUserId:userId];
            if (user == nil) {
                user = [self generateDefaultUserInfo:userId];
                completion(user);
                return;
            }
        }
    }];
}

- (void)getFriendInfo:(NSString *)friendID completion:(void (^)(RCUserInfo *))completion
{
    __block RCUserInfo *resultInfo;
    [RCDHTTPTOOL getUserInfoByUserID:friendID completion:^(RCUserInfo *user) {
        resultInfo = [self generateDefaultUserInfo:friendID];
        completion(user);
        return ;
    }];
}

- (RCUserInfo *)getFriendInFromDB:(NSString *)friendID
{
    RCUserInfo *resultInfo;
    resultInfo = [[RCDDataBaseManager shareInstance] getFriendInfo:friendID];
    if (resultInfo != nil) {
        return resultInfo;
    }
    return nil;
}

- (NSArray *)getFriendInfoList:(NSArray *)friendList
{
    return nil;
}

- (RCUserInfo *)generateDefaultUserInfo:(NSString *)userId
{
    RCUserInfo *defaultUserInfo = [RCUserInfo new];
    defaultUserInfo.userId = userId;
    defaultUserInfo.name = [NSString stringWithFormat:@"name%@", userId];
    defaultUserInfo.portraitUri = @"LOGO";
    return defaultUserInfo;
}
@end
