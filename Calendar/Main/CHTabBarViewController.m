//
//  CHTabBarViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHTabBarViewController.h"

#import "CHNavigationViewController.h"
#import "CHIndexViewController.h"
#import "CHCircleViewController.h"
#import "CHFriendsViewController.h"
#import "CHPersonalViewController.h"
//#import "CHHomeViewController.h"
#import "IMListViewController.h"

#import "UITabBarItem+CHBadge.h"

@interface CHTabBarViewController ()

@end

@implementation CHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabbarItem];
}

- (void)initTabbarItem
{
    //机构列表
    IMListViewController *homeVC = [IMListViewController new];
    [self controller:homeVC title:@"会话" image:@"Origan" selectImage:@"Origan_select"];
    CHNavigationViewController *homeNaVC = [[CHNavigationViewController alloc] initWithRootViewController:homeVC];
    
    //好友
    CHFriendsViewController *friendVC = [CHFriendsViewController new];
    [self controller:friendVC title:@"好友" image:@"Friend" selectImage:@"Friends_select"];
    CHNavigationViewController *friendNaVC = [[CHNavigationViewController alloc] initWithRootViewController:friendVC];
    
//    //首页
//    CHIndexViewController *indexVC = [CHIndexViewController new];
//    [self controller:indexVC title:@"首页" image:@"Index" selectImage:@"Index_select"];
//    CHNavigationViewController *indexNaVC = [[CHNavigationViewController alloc] initWithRootViewController:indexVC];
    
    //朋友圈
    CHCircleViewController *circleVC = [CHCircleViewController new];
    [self controller:circleVC title:@"朋友圈" image:@"Circle" selectImage:@"Circle_select"];
    CHNavigationViewController *circleNaVC = [[CHNavigationViewController alloc] initWithRootViewController:circleVC];
    
    //个人中心
    CHPersonalViewController *personalVC = [CHPersonalViewController new];
    [self controller:personalVC title:@"我的" image:@"Personal" selectImage:@"Personal_select"];
    CHNavigationViewController *personalNaVC = [[CHNavigationViewController alloc] initWithRootViewController:personalVC];
    
    //选中的文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:navigationBarColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
//    //小红点显示
    self.viewControllers = @[homeNaVC, friendNaVC, circleNaVC, personalNaVC];
}

- (void)controller:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:viewController];
//    [self addChildViewController:naVC];
}

@end
