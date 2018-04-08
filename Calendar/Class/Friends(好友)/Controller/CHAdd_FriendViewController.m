//
//  CHAdd_FriendViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/4.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHAdd_FriendViewController.h"

#import "CHManager.h"
#import "CHAddFriendModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "ProgressHUD.h"

#import "CHAddFriendTableViewCell.h"
#import "CHFriend_SearchViewController.h"
#import "CHNavigationViewController.h"

@interface CHAdd_FriendViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *source;
/**
 * 没有好友请求
 */
@property (nonatomic, strong)UIView *noneView;
@end

@implementation CHAdd_FriendViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self createNetRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"新的朋友";
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(clickAddButton)];
}

#pragma mark - 懒加载
- (UIView *)noneView
{
    if (!_noneView) {
        _noneView = [[UIView alloc] initWithFrame:self.view.bounds];
        _noneView.backgroundColor = HexColor(0xffffff);
        UIButton *btn = [[UIButton alloc] initWithFrame:_noneView.bounds];
        [btn setTitle:@"暂时没有好友请求，点我主动去添加吧！" forState:UIControlStateNormal];
        [btn setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
        [_noneView addSubview:btn];
    }
    return _noneView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CHAddFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"ADD"];
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.source.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"好友请求列表";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHAddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADD"];
    if (!cell) {
        cell = [[CHAddFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ADD"];
       
    }
    CHAddFriendModel *model = _source[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.acceptButton.tag = [indexPath item];
    cell.refuseButton.tag = [indexPath item];
    [cell.acceptButton addTarget:self action:@selector(acceptButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.refuseButton addTarget:self action:@selector(refuseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 接受好友请求
- (void)acceptButtonClick:(UIButton *)btn
{
    CHAddFriendModel *model = _source[btn.tag];
    NSString *path = [NSString stringWithFormat:@"%@/%@/accept", CHReadConfig(@"friend_acceptRequest_Url"), model.sender_id];
    [[CHManager manager] requestWithMethod:POST WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        if (responseObject[@"success"]) { // 添加成功
            [ProgressHUD showSuccess:@"好友添加成功"];
            [self.tableView removeFromSuperview];
            [self createNetRequest];
        } else { //添加失败
            [ProgressHUD showError:@"好友添加失败"];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 拒绝好友请求
- (void)refuseButtonClick:(UIButton *)btn
{
    CHAddFriendModel *model = _source[btn.tag];
    NSString *path = [NSString stringWithFormat:@"%@/%@/deny", CHReadConfig(@"friend_refuseReqquest_Url"), model.sender_id];
    [[CHManager manager] requestWithMethod:POST WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        if (responseObject[@"success"]) { // 添加成功
            [ProgressHUD showSuccess:@"拒绝好友添加"];
            [self.tableView removeFromSuperview];
            [self createNetRequest];
        } else { //添加失败
            [ProgressHUD showError:@"拒绝失败"];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 发送好友请求
- (void)clickAddButton
{
    CHFriend_SearchViewController *searchVC = [CHFriend_SearchViewController new];
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:searchVC];
    [self presentViewController:naVC animated:NO completion:^{
        
    }];
}

#pragma mark - 网络请求
- (void)createNetRequest
{
    NSString *path = CHReadConfig(@"friend_unDispose_Url");
    NSDictionary *params = @{
                             @"include":@"sender"
                             };
    [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"]) {
            CHAddFriendModel *model = [CHAddFriendModel mj_objectWithKeyValues:dict];
            [arrayM addObject:model];
        }
        if (arrayM.count != 0) {
            _source = [arrayM copy];
            [self.view addSubview:self.tableView];
        } else {
            [self.view addSubview:self.noneView];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

@end
