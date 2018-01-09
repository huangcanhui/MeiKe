//
//  CHFriend_DetailViewController.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirendListObject.h"

@interface CHFriend_DetailViewController : UIViewController

@property (nonatomic, strong)FirendListObject *object;

@property (nonatomic, copy)void (^whenViewDisAppear)(void); //当页面要消失的时候进行一次刷新

@end
