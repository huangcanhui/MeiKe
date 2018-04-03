//
//  CHUtils.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/3.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHUtils.h"

@implementation CHUtils

@end

@implementation CHUtils (CH_ViewController)
+ (UIViewController *)ch_topppestViewController
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    return vc;
}

@end
