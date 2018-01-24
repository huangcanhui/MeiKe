//
//  mobile.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mobile : NSObject

@end

@class User ;

/**
 * 用户的状态维护
 */
@interface User :NSObject
@property (nonatomic, copy)NSString *access_token; //用户token
@property (nonatomic, copy)NSString *token_type;
@property (nonatomic, copy)NSString *expires_in; //过期时间
@property (nonatomic, copy)NSString *refresh_token; //刷新token
@end

/**
 * 用户的基本信息
 */
@interface UserInfo : NSObject
@property (nonatomic, copy)NSString *province; //省
@property (nonatomic, strong)NSNumber *notifyCount;
@property (nonatomic, strong)NSNumber *members_count;
@property (nonatomic, copy)NSString *nickname; //昵称
@property (nonatomic, copy)NSString *updated_at;//更新时间
@property (nonatomic, strong)NSNumber *gender;//性别
@property (nonatomic, copy)NSString *city; //市
@property (nonatomic, strong)NSNumber *reg_org_id;
@property (nonatomic, copy)NSString *name;//用户名
@property (nonatomic, copy)NSString *nation;//国家
@property (nonatomic, strong)NSNumber *ref_user_id;
@property (nonatomic, strong)NSArray *black_info;
@property (nonatomic, strong)NSNumber *id;
@property (nonatomic, copy)NSString *sex; //性别
@property (nonatomic, copy)NSString *email; //邮箱
@property (nonatomic, copy)NSString *mobile; //手机号码
@property (nonatomic, copy)NSString *avatar; //头像
@property (nonatomic, copy)NSString *county; //区
@property (nonatomic, strong)NSArray *remark_info;
@property (nonatomic, copy)NSString *created_at;//创建时间
@property (nonatomic, copy)NSString *remark;//备注
@end

