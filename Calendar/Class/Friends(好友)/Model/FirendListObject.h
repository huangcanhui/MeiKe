//
//  FirendListObject.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/3.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirendListObject : NSObject
/**
 * 好友ID
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 好友头像
 */
@property (nonatomic, copy)NSString *avatar;
/**
 * 圈子号
 */
@property (nonatomic, copy)NSString *name;
/**
 * 是否实名
 */
@property (nonatomic, assign)BOOL is_vertify;
/**
 * 备注
 */
@property (nonatomic, copy)NSString *nickname;
/**
 * 国家
 */
@property (nonatomic, copy)NSString *nation;
/**
 * 省
 */
@property (nonatomic, copy)NSString *province;
/**
 * 市
 */
@property (nonatomic, copy)NSString *city;
/**
 * 区
 */
@property (nonatomic, copy)NSString *county;
/**
 * 性别
 */
@property (nonatomic, copy)NSString *sex;
/**
 *
 */
@property (nonatomic, copy)NSString *remark;
/**
 * 首字母
 */
@property (nonatomic, copy)NSString *first_letter;
@end
