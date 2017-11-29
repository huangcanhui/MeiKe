//
//  CHCircleViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHCircleViewController.h"

//工具
#import "Masonry.h"
#import "CHNaviButton.h"
#import "CHNavigationViewController.h"
//视图
#import "CHPublishViewController.h"

@interface CHCircleViewController ()
@property (nonatomic, strong)UILabel *testLabel;
@end

@implementation CHCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"朋友圈";
    
    [self initNaviView];
    
    [self test];
    
}

#pragma mark - 导航栏视图
- (void)initNaviView
{
   
//    //添加发布
//    CHNaviButton *rightButton = [CHNaviButton buttonwWithFrame:CGRectMake(0, 0, 35, 35) type:UIButtonTypeCustom andFont:12 andTitle:nil andTitleColor:nil imageName:@"add" andBoolLabel:NO andTmepBlock:^(CHNaviButton *button) {
//        CHPublishViewController *publishVC = [CHPublishViewController new];
//        CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:publishVC];
//        [wself presentViewController:naVC animated:NO completion:nil];
//    }];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    imageView.image = [UIImage imageNamed:@"takePhoto"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    //点击发表带有图像的说说
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightNaviButtonTap)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    
    //长按发表说说
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRightNaviButton)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:longPress];
}

- (void)rightNaviButtonTap
{
    weakSelf(wself);
    CHPublishViewController *pubVC = [CHPublishViewController new];
    pubVC.style = clickGes; //点击
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:pubVC];
    [wself presentViewController:naVC animated:NO completion:nil];
}

- (void)longPressRightNaviButton
{
    weakSelf(wself);
    CHPublishViewController *pubVC = [CHPublishViewController new];
    pubVC.style = clickLongPress; //点击
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:pubVC];
    [wself presentViewController:naVC animated:NO completion:nil];
}

- (void)test
{
    weakSelf(wself);
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还是打飞机熬枯受淡尽快发货时间都会放假阿斯加德化速度回复家还是大家看法哈借款收到回复家含税单价发哈时间的话房价为何就可恢复就是";
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor redColor];
    [wself.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 20, 100));
        make.center.equalTo(wself.view);
    }];
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor yellowColor];
    [wself.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor blackColor];
    [wself.view addSubview:view2];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30) / 2, 120));
//        make.left.and.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(view1);
        make.right.mas_equalTo(-10);
    }];
}


- (UILabel *)testLabel
{
    if (!_testLabel) {
        weakSelf(wself);
        NSLog(@"运行了");
//        _testLabel.frame = CGRectMake(100, 100, 200, 100);
        _testLabel = [[UILabel alloc] init];
        _testLabel.backgroundColor = [UIColor redColor];
        _testLabel.text = @"sdjfhsjkdhfjkashdjkfhajksdhfj ahsdjfhajshdjf hasjdfhajk sdhfjkahsjdfhwiufheusahdfj bsanjdfajskhdfwiuehf ajsdhfjkahsdjkfh ajs";
        [_testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 100));
            make.center.equalTo(wself.view);
        }];

        _testLabel.numberOfLines = 0;
    }
    return _testLabel;
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
