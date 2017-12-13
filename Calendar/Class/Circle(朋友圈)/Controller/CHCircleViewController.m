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
#import "FriendCircleObject.h"
#import "MJRefresh.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "FriendCircleObject.h"

//视图
#import "CHPublishViewController.h"
#import "CHFriendCircleTableViewCell.h"

static NSString *bundleID = @"friendCircle";
@interface CHCircleViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * 导航目录
 */
@property (nonatomic, strong)NSArray *naviArrayM;
@property (nonatomic, strong)NSArray *tableArray; //朋友圈的数据
/**
 * UIScrollView
 */
@property (nonatomic, strong)UIScrollView *naviScrollView;
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation CHCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"朋友圈";
    
    [self initNaviView];
    
    [self.view addSubview:self.naviScrollView];
}

#pragma mark - 导航栏视图
- (void)initNaviView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    imageView.image = [UIImage imageNamed:@"takePhotoNew"];
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

#pragma mark - 创建导航标题
- (UIScrollView *)naviScrollView
{
    if (!_naviScrollView) {
        _naviScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        _naviScrollView.showsHorizontalScrollIndicator = NO;
        _naviScrollView.backgroundColor = HexColor(0x000000);
        _naviScrollView.bounces = NO;
        CGFloat buttonW;
        if (self.naviArrayM.count > 3) {
          buttonW = kScreenWidth / 3;
        } else {
            buttonW = (kScreenWidth - 1) / 2;
        }
        _naviScrollView.contentSize = CGSizeMake(buttonW * self.naviArrayM.count, 45);
        [self addNaviButton];
    }
    return _naviScrollView;
}

- (NSArray *)naviArrayM
{
    //这边应该是一个网络请求
    if (!_naviArrayM) {
        _naviArrayM = @[@"兄弟", @"闺蜜", @"工作", @"公司", @"推荐"];
    }
    return _naviArrayM;
}

- (void)addNaviButton
{
    CGFloat buttonW;
    if (self.naviArrayM.count > 3) {
        buttonW = kScreenWidth / 3;
    } else {
        buttonW = (kScreenWidth - 1) / 2;
    }
    for (int i = 0; i < self.naviArrayM.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((buttonW + 1) * i, 0, buttonW, 44)];
        [btn setTitle:self.naviArrayM[i] forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
        btn.backgroundColor = HexColor(0xffffff);
        btn.tag = 100 + i;
        if (btn.tag == 100) { //默认选中
//            [btn setTitleColor:HexColor(0xffffff) forState:UIControlStateNormal];
//            btn.backgroundColor = GLOBAL_COLOR;
            [btn setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
            [self getNaviMenuWithTag:btn.tag];
        }
        [btn addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviScrollView addSubview:btn];
    }
}

- (void)clickMenuBtn:(UIButton *)btn
{
    [self getNaviMenuWithTag:btn.tag];
    for (UIView *view in self.naviScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag == btn.tag) {
                ((UIButton *)view).selected = YES;
//                ((UIButton *)view).backgroundColor = GLOBAL_COLOR;
//                [((UIButton *)view) setTitleColor:HexColor(0xffffff) forState:UIControlStateNormal];
                [((UIButton *)view) setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
            } else {
                ((UIButton *)view).selected = NO;
//                ((UIButton *)view).backgroundColor = HexColor(0xffffff);
//                [((UIButton *)view) setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
                [((UIButton *)view) setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
            }
        }
    }
}

- (void)getNaviMenuWithTag:(NSUInteger)tag
{
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - 朋友圈的内容

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.naviScrollView.CH_bottom, kScreenWidth, kScreenHeight - self.naviScrollView.CH_height - tabbarHeight - navigationHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册cell
        [_tableView registerClass:[CHFriendCircleTableViewCell class] forCellReuseIdentifier:bundleID];
        
        //添加刷新控件
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [_tableView.mj_header endRefreshing];
        }];
        //上拉加载
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            
            [_tableView.mj_footer endRefreshing];
        }];
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*********************  cell自适应高度 *************************************/
    id model = self.tableArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CHFriendCircleTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8 ) {
        width = kScreenHeight;
    }
    return width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHFriendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bundleID];
    if (!cell) {
        cell = [[CHFriendCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bundleID];
    }
    cell.indexPath = indexPath;
    weakSelf(wself);
    if (!cell.moreButtonClickBlock) {
        [cell setMoreButtonClickBlock:^(NSIndexPath *indexPath) {
            FriendCircleObject *model = wself.tableArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    cell.object = self.tableArray[indexPath.row];
    return cell;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
