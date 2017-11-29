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
@property (nonatomic, copy)NSString *weixin_union_id;//微信id
@property (nonatomic, copy)NSString *qq;//QQ号码
@property (nonatomic, copy)NSString *weixin; //微信号码
@property (nonatomic, strong)NSNumber *add_by;//用户ID，由某个人添加
@property (nonatomic, copy)NSString *updated_at;//更新时间
@property (nonatomic, copy)NSString *name;//用户名
@property (nonatomic, strong)NSNumber *is_black; //是否被拉黑
@property (nonatomic, strong)NSNumber *is_first_password; //是否修改过密码
@property (nonatomic, strong)NSNumber *id;
@property (nonatomic, copy)NSString *card_number; //身份证号码
@property (nonatomic, copy)NSString *email; //邮箱
@property (nonatomic, strong)NSNumber *gender;//性别
@property (nonatomic, copy)NSString *mobile; //手机号码
@property (nonatomic, copy)NSString *avatar; //头像
@property (nonatomic, strong)NSNumber *has_remark; //是否已备注
@property (nonatomic, copy)NSString *weixin_open_id;
@property (nonatomic, assign)BOOL is_verify;//是否已实名
@property (nonatomic, copy)NSString *nick_name; //昵称
@property (nonatomic, strong)NSNumber *is_verity_pending;
@property (nonatomic, copy)NSString *created_at;//创建时间
@property (nonatomic, copy)NSString *remark;//备注
@property (nonatomic, copy)NSString *real_name; //真实姓名
@property (nonatomic, copy)NSString *card_image;//身份证照片
@end

