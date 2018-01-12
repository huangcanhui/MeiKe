//
//  FriendCircleObject.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/11.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

//这个是朋友圈的所有数据模型
#import <Foundation/Foundation.h>

//@class NaviMenuObject;
@class PublisherObject;
@class LikerObject;
@class commentObject;

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleObject : NSObject
/**
 * 是否展示全文按钮
 */
@property (nonatomic, assign)BOOL isOpening;
/**
 * 是否展示更多
 */
@property (nonatomic, assign)BOOL shouldShowMoreButton;
/**
 * 发布的内容
 */
@property (nonatomic, copy)NSString *content;
/**
 * 发布的图片数量
 */
@property (nonatomic, strong)NSArray *picArray;
/**
 * 发布者对象
 */
@property (nonatomic, strong)NSArray <PublisherObject *> *publisher;
/**
 * 点赞对象
 */
@property (nonatomic, strong)NSArray <LikerObject *> *liker;
/**
 * 评论对象
 */
@property (nonatomic, strong)NSArray <commentObject *> *comment;

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


/**
 * 点赞
 */
@interface LikerObject :NSObject
/**
 * 点赞人的名称
 */
@property (nonatomic, copy)NSString *liker;
/**
 * 点赞人的ID
 */
@property (nonatomic, strong)NSNumber *id;

@end

/**
 * 评论
 */
@interface commentObject :NSObject
/**
 * 评论内容
 */
@property (nonatomic, copy)NSString *comment;
/**
 * 发布者的昵称
 */
@property (nonatomic, copy)NSString *firstUserName;
/**
 * 发布者的ID
 */
@property (nonatomic, strong)NSNumber *firstUserID;
/**
 * 评论者的昵称
 */
@property (nonatomic, copy)NSString *secondUserName;
/**
 * 评论者的ID
 */
@property (nonatomic, strong)NSNumber *secondUserID;

@end



NS_ASSUME_NONNULL_END
