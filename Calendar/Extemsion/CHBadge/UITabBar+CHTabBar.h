//
//  UITabBar+CHTabBar.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (CHTabBar)
/**
 *  显示小红点
 *
 *  @param index 传入需要现实的位置
 */
- (void)showBadgeIndex:(NSInteger)index;

/**
 *  隐藏小红点
 *
 *  @param index 传入需要隐藏的位置
 */
- (void)hideBadgeIndex:(NSInteger)index;
@end
