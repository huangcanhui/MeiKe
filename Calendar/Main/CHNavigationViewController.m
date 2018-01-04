//
//  CHNavigationViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHNavigationViewController.h"

@interface CHNavigationViewController ()

@end

@implementation CHNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        UINavigationBar *bar = self.navigationBar;
        bar.barTintColor = GLOBAL_COLOR; //设置导航栏背景颜色
        [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        bar.tintColor = [UIColor whiteColor]; //设置导航栏view的颜色
        bar.translucent = NO; //设置为不透明
        [bar setShadowImage:[UIImage new]];
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], //设置title颜色
                                      NSFontAttributeName:[UIFont systemFontOfSize:16]
                                      }];
        //设置UIBarButtonItem的外观
        UIBarButtonItem *barItem = [UIBarButtonItem appearance];
        //item上边的文字样式
        NSDictionary *fontDic = @{NSForegroundColorAttributeName:[UIColor whiteColor], //设置barButton里面字体的颜色
                                  NSFontAttributeName:[UIFont systemFontOfSize:14]
                                  };
        [barItem setTitleTextAttributes:fontDic forState:UIControlStateNormal];
        [barItem setTitleTextAttributes:fontDic forState:UIControlStateHighlighted];
        
        //设置返回键
        UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        bar.backIndicatorImage = image;
        bar.backIndicatorTransitionMaskImage = image;
        [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-kScreenHeight, 0) forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
