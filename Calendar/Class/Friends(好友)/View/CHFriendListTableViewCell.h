//
//  CHFriendListTableViewCell.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHPersonalData.h"
#import "FirendListObject.h"

@interface CHFriendListTableViewCell : UITableViewCell

@property (nonatomic, strong)CHPersonalData *model;

@property (nonatomic, strong)FirendListObject *object;

@end
