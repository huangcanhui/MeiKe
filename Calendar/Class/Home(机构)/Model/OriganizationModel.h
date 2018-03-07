//
//  OriganizationModel.h
//  Calendar
//
//  Created by huangcanhui on 2018/3/7.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailObject;

@interface OriganizationModel : NSObject
/**
 * 标题名称
 */
@property (nonatomic, copy)NSString *title;
/**
 * 费用对象
 */
@property (nonatomic, strong)NSArray <DetailObject *> *detail;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end


/**
 * 费用明细信息
 */
@interface DetailObject : NSObject
/**
 * 费用价格
 */
@property (nonatomic, copy)NSString *price;
/**
 * 费用名称
 */
@property (nonatomic, copy)NSString *title;
/**
 * 使用量
 */
@property (nonatomic, copy)NSString *use;
/**
 * 花销
 */
@property (nonatomic, copy)NSString *cost;
/**
 * 备注
 */
@property (nonatomic, copy)NSString *memo;

@end
