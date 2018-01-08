//
//  FriendListGroup.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirendListObject.h"

@interface FriendListGroup : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSArray <FirendListObject *> *list;
@end
