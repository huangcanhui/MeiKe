//
//  CHFriendCircleTableViewCell.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/12.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCircleObject.h"

@protocol CHFriendCircleTableViewCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickCommentButtonInCell:(UITableViewCell *)cell;

@end

@interface CHFriendCircleTableViewCell : UITableViewCell

@property (nonatomic, strong)FriendCircleObject *object;

@property (nonatomic, weak)id<CHFriendCircleTableViewCellDelegate> delegate;

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, copy)void (^moreButtonClickBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy)void (^didClickCommentLabelBlock)(NSNumber *commentId, CGRect rectInWindow, NSIndexPath *indexPath, NSString *commentName);

@end
