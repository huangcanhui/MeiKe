//
//  CHFriendCellCommentView.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/12.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHFriendCellCommentView : UIView

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

/**
 * 评论的点击回调
 */
@property (nonatomic, copy)void (^didClickCommentLabelBlock)(NSNumber *commrntId, CGRect rectWindow, NSString *commentName);

@end
