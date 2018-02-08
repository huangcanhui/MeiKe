//
//  CHIndexViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/24.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHIndexViewController.h"

#import "CH_Publish_View.h"

#import "CHAdd_FriendViewController.h"
#import "CHScanCodeViewController.h"

@interface CHIndexViewController ()
/**
 * 计数器
 */
@property (nonatomic, assign)int count;
/**
 * 导航栏右上角视图
 */
@property (nonatomic, strong)CH_Publish_View *publishView;

@end

@implementation CHIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"首页";
    
    [self initAttribute];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightNavigationItemEvent)];
}

#pragma mark - 初始化
- (void)initAttribute
{
    _count = 0;
}

#pragma mark - 导航栏右侧的点击事件
- (void)clickRightNavigationItemEvent
{
    CGFloat width = kScreenWidth / 3;
    NSArray *array = @[@"添加朋友", @"扫一扫", @"我的二维码"];
    weakSelf(wself);
    if (_count % 2 == 0) {
        _publishView = [CH_Publish_View setPublishViewFrame:CGRectMake(kScreenWidth - width - 8, 8, width, array.count * 55) andBackground:HexColor(0xffffff) andTitleArray:array andImageArray:nil andTitleColor:HexColor(0xffffff) andTitleFont:13 andTitleBackground:HexColor(0x000000)];
        _publishView.whenButtonClick = ^(NSInteger tag) {
            switch (tag) {
                case 0:
                {
                    CHAdd_FriendViewController *friendVC = [CHAdd_FriendViewController new];
                    [wself.navigationController pushViewController:friendVC animated:NO];
                }
                    break;
                case 1:
                {
                    CHScanCodeViewController *scan = [CHScanCodeViewController new];
                    //        CHNavigationViewController *navc = [[CHNavigationViewController alloc] initWithRootViewController:scan];
                    //        [wself presentViewController:navc animated:YES completion:nil];
                    [wself.navigationController pushViewController:scan animated:NO];
                }
                    break;
                case 2:
                    NSLog(@"我的二维码");
                    break;
                    
                default:
                    break;
            }
        };
        [self.view addSubview:_publishView];
    } else {
        [_publishView removeFromSuperview];
    }
    _count ++;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _count = 0;
    [_publishView removeFromSuperview];
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
