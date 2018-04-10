//
//  CHOrganListModel.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/10.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TypeObject;

@interface CHOrganListModel : NSObject
/**
 * 状态
 */
@property (nonatomic, strong)NSNumber *status;
/**
 * 电话号码
 */
@property (nonatomic, copy)NSString *tel;
/**
 * 类型ID
 */
@property (nonatomic, strong)NSNumber *type_id;
/**
 * 机构成员数量
 */
@property (nonatomic, strong)NSNumber *memebers_count;
/**
 * 经度
 */
@property (nonatomic, copy)NSString *lng;
/**
 * 纬度
 */
@property (nonatomic, copy)NSString *lat;
/**
 * 封面
 */
@property (nonatomic, copy)NSString *cover;
/**
 * 标识
 */
@property (nonatomic, copy)NSString *sign;
/**
 * 介绍
 */
@property (nonatomic, copy)NSString *introduction;
/**
 * 地址
 */
@property (nonatomic, copy)NSString *address;
/**
 * 机构名称
 */
@property (nonatomic, copy)NSString *name;
/**
 * 机构简称
 */
@property (nonatomic, copy)NSString *simple_name;
/**
 * 机构图片
 */
@property (nonatomic, copy)NSString *logo;
/**
 * 机构ID
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 类型
 */
@property (nonatomic, strong)TypeObject *type;

@end


/**
 * 这是类型对象
 */
@interface TypeObject : NSObject
/**
 * 介绍
 */
@property (nonatomic, copy)NSString *introduction;
/**
 * id
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 标识
 */
@property (nonatomic, copy)NSString *sign;
/**
 * 名称
 */
@property (nonatomic, copy)NSString *name;
/**
 * 图片
 */
@property (nonatomic, copy)NSString *icon;
@end
