//
//  Address.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/10.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
/**
 * 标题
 */
@property (nonatomic, copy)NSString *name;
/**
 * 获取地址
 */
@property (nonatomic, copy)NSString *address;
/**
 * 经纬度
 */
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *lng;
@end
