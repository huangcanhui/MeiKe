//
//  UIViewController+CH.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "UIViewController+CH.h"
#import "CHLoginViewController.h"
#import "CHNavigationViewController.h"

@implementation UIViewController (CH)

- (void)showLogin
{
    CHLoginViewController *loginVC = [CHLoginViewController new];
    CHNavigationViewController *navc = [[CHNavigationViewController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navc animated:YES completion:nil];
}

- (void)showResgister
{
    //    CHRegisterViewController *resVC = [CHRegisterViewController new];
    //    CHNavigationController *navc = [[CHNavigationController alloc] initWithRootViewController:resVC];
    //    [self presentViewController:navc animated:YES completion:nil];
}

@end
