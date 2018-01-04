//
//  FriendListModel.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/2.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendListModel : NSObject
/**
 * 圈子ID
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 圈子名称
 */
@property (nonatomic, copy)NSString *name;
/**
 * 圈子图片
 */
@property (nonatomic, copy)NSString *icon;
/**
 * 圈子介绍
 */
@property (nonatomic, copy)NSString *introduction;
/**
 * 圈子封面
 */
@property (nonatomic, copy)NSString *cover;
/**
 * 创建时间
 */
@property (nonatomic, copy)NSString *created_at;
/**
 * 更新时间
 */
@property (nonatomic, copy)NSString *updated_at;

@end
