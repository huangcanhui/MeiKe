//
//  CHPersonalViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPersonalViewController.h"

#import "CHUserView.h"
#import "CHPersonalModel.h"
#import "CHPersonalGroup.h"
#import "MJExtension.h"
#import "UserModel.h"

#import "CHPersonalTableViewCell.h"
#import "CHFootPrintViewController.h"
#import "CHPhotoViewController.h"
#import "CHGameViewController.h"
#import "CHCustomServiceViewController.h"
#import "CHAboutUsViewController.h"
#import "CHSetUpViewController.h"
#import "CHLoginViewController.h"
#import "CHNavigationViewController.h"
#import "CHPersonalDataViewController.h"

static NSString *cellBundle = @"PERSONAL";
@interface CHPersonalViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *itemGroups;
/**
 * 头视图
 */
@property (nonatomic, strong)CHUserView *userView;
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation CHPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"个人中心";
    
    [self initUI];
}

#pragma mark - 视图的创建
- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.tableFooterView = [[UIView alloc] init];
    //去除掉横线
    tableView.separatorColor = [UIColor clearColor];
    //注册cell
    [tableView registerNib:[UINib nibWithNibName:@"CHPersonalTableViewCell" bundle:nil] forCellReuseIdentifier:cellBundle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginView) name:@"NavigationMessage" object:nil];
    //创建登录
    CHUserView *userView = [CHUserView headerView];
    userView.user = self.userModel.user;
    _userView = userView;
    userView.whenLoginBtnClick = ^{
        if (![UserModel onLine]) {
            [self loginClick];
        } else {
            [self PersonalData];
        }
    };
    tableView.tableHeaderView = _userView;
    
    [self.view addSubview:tableView];
}

- (void)loginView
{
    _userView.user = self.userModel.user;
}

#pragma mark 登录
- (void)loginClick
{
    CHLoginViewController *loginVC = [CHLoginViewController new];
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:loginVC];
    [self presentViewController:naVC animated:NO completion:nil];
}

#pragma mark 获取个人资料信息
- (void)PersonalData
{
    CHPersonalDataViewController *dataVC = [CHPersonalDataViewController new];
    [self.navigationController pushViewController:dataVC animated:NO];
}

#pragma mark UITableView.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CHPersonalGroup *group = self.itemGroups[section];
    return group.activity.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellBundle];
    if (!cell) {
        cell = [[CHPersonalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBundle];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CHPersonalGroup *group = self.itemGroups[indexPath.section];
    CHPersonalModel *model = group.activity[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPersonalGroup *group = self.itemGroups[indexPath.section];
    CHPersonalModel *model = group.activity[indexPath.row];
    if ([model.title isEqualToString:@"我的足迹"]) {
        CHFootPrintViewController *footVC = [CHFootPrintViewController new];
        [self.navigationController pushViewController:footVC animated:NO];
    } else if ([model.title isEqualToString:@"我的相册"]) {
        CHPhotoViewController *photoVC = [CHPhotoViewController new];
        [self.navigationController pushViewController:photoVC animated:NO];
    } else if ([model.title isEqualToString:@"小游戏"]) {
        CHGameViewController *gameVC = [CHGameViewController new];
        [self.navigationController pushViewController:gameVC animated:NO];
    } else if ([model.title isEqualToString:@"我的客服"]) {
        CHCustomServiceViewController *customVC = [CHCustomServiceViewController new];
        [self.navigationController pushViewController:customVC animated:NO];
    } else if ([model.title isEqualToString:@"关于我们"]) {
        CHAboutUsViewController *aboutVC = [CHAboutUsViewController new];
        [self.navigationController pushViewController:aboutVC animated:NO];
    } else if ([model.title isEqualToString:@"设置"]) {
        CHSetUpViewController *setVC = [CHSetUpViewController new];
        [self.navigationController pushViewController:setVC animated:NO];
    }
}

#pragma mark - 懒加载
- (NSArray *)itemGroups
{
    if (!_itemGroups) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CHPersonalList" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _itemGroups = [CHPersonalGroup mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _itemGroups;
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
