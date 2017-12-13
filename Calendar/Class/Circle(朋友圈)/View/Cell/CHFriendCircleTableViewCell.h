//
//  CHFriendCircleTableViewCell.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/12.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCircleObject.h"

@interface CHFriendCircleTableViewCell : UITableViewCell

@property (nonatomic, strong)FriendCircleObject *object;

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, copy)void (^moreButtonClickBlock)(NSIndexPath *indexPath);

@end
