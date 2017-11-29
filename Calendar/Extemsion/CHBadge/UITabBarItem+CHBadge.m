//
//  UITabBarItem+CHBadge.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "UITabBarItem+CHBadge.h"
#import "UIView+CHBadge.h"

@implementation UITabBarItem (CHBadge)

- (void)showBadge
{
    [[self getActualBadgeSuperView] showBadge]; //调用UIView的显示方法
}

- (void)hidenBadge
{
    [[self getActualBadgeSuperView] hidenBadge]; //调用UIView的隐藏方法
}

- (UIView *)getActualBadgeSuperView
{
    // 1.get UITabbarButtion
    UIView *bottomView = [self valueForKeyPath:@"_view"];
    
    // 2.get imageView, to make sure badge front at anytime.
    UIView *actualSuperView = nil;
    if (bottomView) {
        actualSuperView = [self findView:bottomView firstSubviewWithClass:NSClassFromString(@"UITabBarSwappableImageView")];
    }
    // badge label will be added onto imageView
    return actualSuperView;
}

/**
 * 获取UIView
 */
- (UIView *)findView:(UIView *)view firstSubviewWithClass:(Class)cls
{
    __block UIView *targetView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subview isKindOfClass:cls]) {
            targetView = subview;
            *stop = YES;
        }
    }];
    return targetView;
}

@end
