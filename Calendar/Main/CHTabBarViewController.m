//
//  CHTabBarViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHTabBarViewController.h"

#import "CHNavigationViewController.h"
#import "CHCircleViewController.h"
#import "CHFriendsViewController.h"
#import "CHPersonalViewController.h"

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
    //朋友圈
    CHCircleViewController *circleVC = [CHCircleViewController new];
    [self controller:circleVC title:@"朋友圈" image:@"Circle" selectImage:@"Circle_select"];
    CHNavigationViewController *circleNaVC = [[CHNavigationViewController alloc] initWithRootViewController:circleVC];
    
    //好友
    CHFriendsViewController *friendVC = [CHFriendsViewController new];
    [self controller:friendVC title:@"好友" image:@"Friend" selectImage:@"Friends_select"];
    CHNavigationViewController *friendNaVC = [[CHNavigationViewController alloc] initWithRootViewController:friendVC];
    
    //个人中心
    CHPersonalViewController *personalVC = [CHPersonalViewController new];
    [self controller:personalVC title:@"我的" image:@"Personal" selectImage:@"Personal_select"];
    CHNavigationViewController *personalNaVC = [[CHNavigationViewController alloc] initWithRootViewController:personalVC];
    
    //选中的文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:navigationBarColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    //小红点显示
    self.viewControllers = @[circleNaVC, friendNaVC, personalNaVC];
    [self.tabBar.items[0] showBadge];
    [self.tabBar.items[1] showBadge];
    
}

- (void)controller:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:viewController];
//    [self addChildViewController:naVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
