//
//  FriendCircleObject.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/11.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

//这个是朋友圈的所有数据模型
#import <Foundation/Foundation.h>

@class NaviMenuObject;
@class PublisherObject;

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleObject : NSObject
/**
 * 菜单对象
 */
@property (nonatomic, strong)NaviMenuObject *menu;
/**
 * 发布者对象
 */
@property (nonatomic, strong)PublisherObject *publisher;

@end



/**
 * 朋友圈菜单
 */
@interface NaviMenuObject : NSObject
/**
 * 圈子名称
 */
@property (nonatomic, copy)NSString *circleName;
/**
 * 是否未读消息
 */
@property (nonatomic, assign)BOOL isUnread;
/**
 * 未读的消息数量
 */
@property (nonatomic, strong)NSNumber *unreadCount;
/**
 * 圈子id
 */
@property (nonatomic, strong)NSNumber *id;

@end


/**
 * 发布者的信息
 */
@interface PublisherObject : NSObject
/**
 * ID
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 昵称
 */
@property (nonatomic, copy)NSString *remark;
/**
 * 头像
 */
@property (nonatomic, copy)NSString *avatar;

@end

NS_ASSUME_NONNULL_END
