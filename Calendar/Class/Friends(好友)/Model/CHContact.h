//
//  CHContact.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/7.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHContact : NSObject
/**
 * 获取用户的首字母
 */
@property (nonatomic, copy)NSString *initial;
/**
 * 获取用户的姓
 */
@property (nonatomic, copy)NSString *familyName;
/**
 * 获取用户的名
 */
@property (nonatomic, copy)NSString *givenName;
/**
 * 获取用户的手机号
 */
@property (nonatomic, strong)NSArray *phoneNumebers;
/**
 * 获取用户的头像
 */
@property (nonatomic, copy)NSString *avatar;
@end
