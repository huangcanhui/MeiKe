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

@property (nonatomic, assign, getter=isLiked)BOOL liked;
/**
 * 说说的ID
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 发布的内容
 */
@property (nonatomic, copy)NSString *content;
/**
 * 是否是自己发布
 */
@property (nonatomic, assign)BOOL is_mine;
/**
 * 是否仅自己可看
 */
@property (nonatomic, assign)BOOL is_private;
/**
 * 发布的图片数量
 */
@property (nonatomic, strong)NSArray *photos;
/**
 * 发布者对象
 */
@property (nonatomic, strong)PublisherObject *owner;
/**
 * 发表说说时间
 */
@property (nonatomic, copy)NSString *created_at;
/**
 * 点赞对象
 */
@property (nonatomic, strong)NSArray <LikerObject *> *liker;
/**
 * 评论对象
 */
@property (nonatomic, strong)NSArray <commentObject *> *latestComments;
/**
 * 通知某人查看
 */
@property (nonatomic, strong)NSArray *notify_users;

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
@property (nonatomic, copy)NSString *nickname;
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
