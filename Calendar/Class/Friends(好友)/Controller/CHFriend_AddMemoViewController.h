//
//  CHFriend_AddMemoViewController.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirendListObject.h"

@interface CHFriend_AddMemoViewController : UIViewController

@property (nonatomic, strong)FirendListObject *obj;

@property (nonatomic, copy)void (^setNameAndCommunity)(NSString *name, NSString *community);

@end
