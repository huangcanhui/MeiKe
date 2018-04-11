//
//  RCDHttpTool.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "RCDHttpTool.h"
#import "RCDDataBaseManager.h"
#import "CHManager.h"

@implementation RCDHttpTool

+ (RCDHttpTool *)shareInstance
{
    static RCDHttpTool *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)getUserInfoByUserID:(NSString *)userID completion:(void (^)(RCUserInfo *))completion
{
    //到本地数据库中查找用户信息是否已经存在
    RCUserInfo *userInfo = [[RCDDataBaseManager shareInstance] getUserByUserId:userID];
    if (!userInfo) {
        NSString *path = CHReadConfig(@"appoint_UserInfo_Url");
        [[CHManager manager] requestWithMethod:GET WithPath:[NSString stringWithFormat:@"%@/%@", path, userID] WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
//            for (NSDictionary *dict in responseObject[@"data"]) {
                RCUserInfo *user = [RCUserInfo new];
                user.userId = responseObject[@"data"][@"id"];
                user.name = responseObject[@"data"][@"nickname"];
                user.portraitUri = responseObject[@"data"][@"avatar"];
                if (!user.portraitUri || user.portraitUri.length <= 0) {
                    user.portraitUri = @"LOGO";
                }
//                //将数据插入表中
//                [[RCDDataBaseManager shareInstance] insertUserToDB:user];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(user);
                    });
                }
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }
}

- (void)setUserPortraitUri:(NSString *)portraitUri complete:(void (^)(BOOL))result
{
    
}

- (void)getFriendDetailsWithFriendId:(NSString *)friendId success:(void (^)(RCUserInfo *))success failure:(void (^)(NSError *))failure
{
    
}
@end
