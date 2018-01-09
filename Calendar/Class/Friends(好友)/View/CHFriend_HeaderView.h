//
//  CHFriend_HeaderView.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirendListObject.h"

@interface CHFriend_HeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic, strong)FirendListObject *obj;

@end
