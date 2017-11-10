//
//  UITabBarItem+CHBadge.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (CHBadge)

/**
 * 显示小红点
 * 需要在哪个item上面显示红点时，就用那个item调用
 */
- (void)showBadge;

/**
 * 隐藏小红点
 * 需要隐藏哪个item上面红点时，就用那个item调用
 */
- (void)hidenBadge;

@end
