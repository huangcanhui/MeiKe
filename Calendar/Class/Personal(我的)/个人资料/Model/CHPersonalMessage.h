//
//  CHPersonalMessage.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/24.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHPersonalMessage : NSObject
/**
 * 用户头像
 */
@property (nonatomic, copy)NSString *avatar;
/**
 * 昵称
 */
@property (nonatomic, copy)NSString *nickname;
/**
 * 手机号
 */
@property (nonatomic, copy)NSString *mobile;
/**
 * 圈子号
 */
@property (nonatomic, copy)NSString *remark;
@end
