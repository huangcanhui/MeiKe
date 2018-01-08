//
//  CHAddFriendTableViewCell.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/4.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHAddFriendModel.h"

@interface CHAddFriendTableViewCell : UITableViewCell
/**
 * 接受按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
/**
 * 拒绝按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (nonatomic, strong)CHAddFriendModel *model;

@end
