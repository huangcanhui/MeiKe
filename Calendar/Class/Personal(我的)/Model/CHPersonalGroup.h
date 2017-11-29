//
//  CHPersonalGroup.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHPersonalModel.h"

@interface CHPersonalGroup : NSObject

/**
 * 标题
 */
@property (nonatomic, copy)NSString *title;

/**
 * 数组
 */
@property (nonatomic, strong)NSArray<CHPersonalModel *>*activity;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
