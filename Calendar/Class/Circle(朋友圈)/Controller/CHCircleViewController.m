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
#import "UserModel.h"
#import "UIViewController+CH.h"
#import "CHManager.h"
#import "FriendListModel.h"
#import "MJExtension.h"

//视图
#import "CHFriendCircleTableViewCell.h"
#import "CHPublish_Photo_ContentViewController.h"

static NSString *bundleID = @"friendCircle";
@interface CHCircleViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * 导航目录
 */
@property (nonatomic, strong)NSArray *naviArrayM;
@property (nonatomic, strong)NSArray *tableArray; //朋友圈的数据
@property (nonatomic, strong)NSMutableArray *arrayM; //中间键
/**
 * UIScrollView
 */
@property (nonatomic, strong)UIScrollView *naviScrollView;
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 页码
 */
@property (nonatomic, assign)int page;
/**
 * 记录选中的圈子ID
 */
@property (nonatomic, strong)NSNumber *communityID;
@end

@implementation CHCircleViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (![UserModel onLine]) {
        [self showLogin];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"朋友圈";
    
    _arrayM = [NSMutableArray array];
    
    _page = 1;
    
    [self initNaviView];
    
    [self requestData];
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
    CHPublish_Photo_ContentViewController *pubVC = [[CHPublish_Photo_ContentViewController alloc] init];
    pubVC.type = typeWithPhotoAndContent; //点击
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:pubVC];
    [wself presentViewController:naVC animated:NO completion:nil];
}

- (void)longPressRightNaviButton
{
    weakSelf(wself);
    CHPublish_Photo_ContentViewController *pubVC = [[CHPublish_Photo_ContentViewController alloc] init];;
    pubVC.type = typeWithContent; //点击
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

#pragma mark - 网络数据请求
- (void)requestData
{
    [[CHManager manager] requestWithMethod:GET WithPath:CHReadConfig(@"community_List_Url") WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"]) {
            FriendListModel *obj = [FriendListModel mj_objectWithKeyValues:dict];
            [arrayM addObject:obj];
        }
        _naviArrayM = [arrayM copy];
        [self.view addSubview:self.naviScrollView];
        [self.view addSubview:self.tableView];
    } WithFailurBlock:^(NSError *error) {
        
    }];
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
        FriendListModel *list = self.naviArrayM[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((buttonW + 1) * i, 0, buttonW, 44)];
        [btn setTitle:list.name forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
        btn.backgroundColor = HexColor(0xffffff);
        btn.tag = 100 + i;
        if (btn.tag == 100) { //默认选中
            [btn setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
            self.communityID = list.id;
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
                [((UIButton *)view) setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
            } else {
                ((UIButton *)view).selected = NO;
                [((UIButton *)view) setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
            }
        }
    }
}

- (void)getNaviMenuWithTag:(NSUInteger)tag
{
    FriendListModel *list = self.naviArrayM[tag - 100];
    self.communityID = list.id;
    [_arrayM removeAllObjects];
    [self requestDataWithPage:self.page andCommunityID:list.id];
}

#pragma mark - 朋友圈的内容请求
- (void)requestDataWithPage:(int)page andCommunityID:(NSNumber *)communityID
{
    NSDictionary *params = @{
                             @"page":[NSString stringWithFormat:@"%d", page],
                             @"page_size":@"15",
                             @"community":communityID,
                             @"include":@"publisher"
                             };
    [[CHManager manager] requestWithMethod:GET WithPath:CHReadConfig(@"community_notes_Url") WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            FriendCircleObject *obj = [FriendCircleObject mj_objectWithKeyValues:dict];
            [_arrayM addObject:obj];
        }
        self.tableArray = [_arrayM copy];
        [self.tableView reloadData];
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 朋友圈的内容

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.naviScrollView.CH_bottom, kScreenWidth, kScreenHeight - self.naviScrollView.CH_height - tabbarHeight - navigationHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        
        //注册cell
        [_tableView registerClass:[CHFriendCircleTableViewCell class] forCellReuseIdentifier:bundleID];
        
        //添加刷新控件
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [_arrayM removeAllObjects]; //移除数据
            [self requestDataWithPage:_page andCommunityID:self.communityID];//网络请求
            [_tableView.mj_header endRefreshing];
        }];
        //上拉加载
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            _page ++;
            [self requestDataWithPage:_page andCommunityID:self.communityID]; //网络请求
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
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"object" cellClass:[CHFriendCircleTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    //适配iOS7
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

@end
