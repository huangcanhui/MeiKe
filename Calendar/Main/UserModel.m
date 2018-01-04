//
//  UserModel.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "UserModel.h"
#import "CHTime.h"
#import "CHManager.h"
#import "UIViewController+CH.h"
#import "ProgressHUD.h"
#import "MJExtension.h"

static float expried_time = 21600; //accesstoken的有效时长
static float refresh_time = 604800; //refresh_token 的有效时长（以秒为单位, 7天） 7 * 24 * 3600

@implementation UserModel

+ (instancetype)defaultInstance
{
    static UserModel *obj = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        obj = [[self alloc] init];
        [obj loadCache];
    });
    return obj;
}

- (void)loadCache
{
    self.user = [User readUserDefaultWithKey:@"UserModel.user"];
    self.userInfo = [UserInfo readUserDefaultWithKey:@"UserModel.info"];
}

- (void)saveCache
{
    [self.user writeUserDefaultWithKey:@"UserModel.user"];
    [self.userInfo writeUserDefaultWithKey:@"UserModel.info"];
}

- (void)clearCache
{
    [self.user removeUserDefaultWithKey:@"UserModel.user"];
    [self.userInfo removeUserDefaultWithKey:@"UserModel.info"];
    NSString *oldTime = [NSString readUserDefaultWithKey:@"currentTime"];
    [oldTime removeUserDefaultWithKey:@"currentTime"];
    self.userInfo = nil;
    self.user = nil;
}

/**
 * 退出登录
 */
- (void)logout
{
    [self clearCache];
}

- (void)kickout
{
    [self clearCache];
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    if (_userInfo) {
        [self saveCache];
    }
}

+ (BOOL)onLine
{
    NSString *time = [CHTime getNowTimeTimestamp2];
    NSString *oldTime = [NSString readUserDefaultWithKey:@"currentTime"];
    if ([oldTime floatValue] + refresh_time > [time floatValue]) { //当前时间小于refresh_token的有效时长
        return YES;
    }
    return NO;
}

- (void)calculateTime
{
    NSString *time = [CHTime getNowTimeTimestamp2];
    NSString *oldTime = [NSString readUserDefaultWithKey:@"currentTime"];
    if ([oldTime isBlank] == YES) return;
    if ([oldTime floatValue] + expried_time <= [time floatValue]) { //当前时间大于登录时间，即access_token过期
        self.user = [User readUserDefaultWithKey:@"UserModel.user"];
        NSDictionary *dict = @{
                               @"client_id":@"1",
                               @"client_secret":@"Km4QFEIMIBtzdIASiR0MN7cnrJsa2eaQUkbStdDW",
                               @"grant_type":@"refresh_token",
                               @"refresh_token":self.user.refresh_token
                               };
        NSString *path = CHReadConfig(@"login_refreshToken_Url");
        [[CHManager manager] requestWithMethod:POST WithPath:path WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
            User *user = [User mj_objectWithKeyValues:dic];
            //存储
            self.user = user;
            [[CHTime getNowTimeTimestamp2] writeUserDefaultWithKey:@"currentTime"];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    } else {
        [ProgressHUD showError:@"登录已过期，请重新登录"];
        
    }
}

- (void)info
{
    [self calculateTime]; //先要判断token是否已经过期
    NSString *path = CHReadConfig(@"login_UserInfo_Url");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
            UserInfo *info = [UserInfo mj_objectWithKeyValues:responseObject];
            //存储
            self.userInfo = info;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GETUSERINFO" object:nil];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    });
}

@end
