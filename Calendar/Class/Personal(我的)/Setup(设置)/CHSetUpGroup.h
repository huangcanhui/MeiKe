//
//  CHSetUpGroup.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHSetUpModel.h"

@interface CHSetUpGroup : NSObject

/**
 * 标题
 */
@property (nonatomic, copy)NSString *title;
/**
 * 图片
 */
@property (nonatomic, copy)NSString *icon;
/**
 * 子目录
 */
@property (nonatomic, strong)NSArray <CHSetUpModel *> *project;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
