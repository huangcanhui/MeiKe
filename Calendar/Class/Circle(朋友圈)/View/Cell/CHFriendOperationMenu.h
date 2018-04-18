//
//  CHFriendOperationMenu.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/18.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHFriendOperationMenu : UIView

/**
 * 是否展示
 */
@property (nonatomic, assign, getter=isShowing)BOOL show;
/**
 * 点赞的回调
 */
@property (nonatomic, copy)void (^likeButtonClickedOPeration)(void);
/**
 * 评论的回调
 */
@property (nonatomic, copy)void (^commentButtonClickOperation)(void);
@end
