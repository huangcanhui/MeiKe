//
//  CHSetUpViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/15.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSetUpViewController.h"

#import "CHSetUpModel.h"
#import "CHSetUpGroup.h"
#import "MJExtension.h"
#import "CHSaveCache.h"
#import "ProgressHUD.h"
#import "CHSettingModel.h"
#import "UserModel.h"
#import <RongIMKit/RongIMKit.h>

#import "CHSetUpDetailViewController.h"
#import "UIViewController+CH.h"

static NSString *bundle = @"SETUP";
@interface CHSetUpViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *dataSource;
/**
 * 缓存
 */
@property (nonatomic, assign)CGFloat cacheSize;
@property (nonatomic, copy)NSString *cacheString;
/**
 * 获取图片模式
 */
@property (nonatomic, strong)NSString *imageMode;
/**
 * 退出登录
 */
@property (nonatomic, strong)UIView *logoutView;
@end

@implementation CHSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"设置";
    
    [self initAttribute];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 初始化
- (void)initAttribute
{
    //内存
    self.cacheString = self.cacheSize > 1 ? [NSString stringWithFormat:@"缓存:%.2fM", self.cacheSize] : [NSString stringWithFormat:@"缓存:%.2fK", self.cacheSize * 1024.0];
    //图片质量
    CHSettingModel *settingModel = [CHSettingModel defaultInstance];
    switch (settingModel.imageMode) {
        case ImageModeAuto:
            self.imageMode = @"智能模式";
            break;
        case ImageModeNormal:
            self.imageMode = @"普通模式";
            break;
        case ImageModeHighQuality:
            self.imageMode = @"高清模式";
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    
        if ([UserModel onLine]) {
            _tableView.tableFooterView = self.logoutView;
        } else {
            _tableView.tableFooterView = [[UIView alloc] init];
        }
    }
    return _tableView;
}

#pragma mark - UITableView.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CHSetUpGroup *group = self.dataSource[section];
    return group.project.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bundle];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bundle];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //小箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中时的颜色
    }
    CHSetUpGroup *group = self.dataSource[indexPath.section];
    CHSetUpModel *model = group.project[indexPath.row];
    cell.textLabel.text = model.title;
//    cell.detailTextLabel.text = model.subtitle;
    if ([model.title isEqualToString:@"清理缓存"]) {
        cell.detailTextLabel.text = self.cacheString;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    if ([model.title isEqualToString:@"图片质量"]) {
        cell.detailTextLabel.text = self.imageMode;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHSetUpGroup *group = self.dataSource[indexPath.section];
    CHSetUpModel *model = group.project[indexPath.row];
    if ([model.title isEqualToString:@"隐私"]) {
        
    } else if ([model.title isEqualToString:@"新消息通知"]) {
        
    } else if ([model.title isEqualToString:@"意见反馈"]) {
        CHSetUpDetailViewController *detailVC = [CHSetUpDetailViewController new];
        detailVC.mode = setupWithAdvince;
        detailVC.naviItemTitle = @"意见反馈";
        [self.navigationController pushViewController:detailVC animated:NO];
    } else if ([model.title isEqualToString:@"帮助中心"]) {
        
    } else if ([model.title isEqualToString:@"清理缓存"]) {
        [self alertWithTitle:@"清除缓存" message:self.cacheString cancelTitle:@"取消" otherTitles:@"清理" block:^{
            [CHSaveCache cleanCaches:[CHSaveCache getCachePath]];
            self.cacheString = @"0K";
            [self.tableView reloadData];
//            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            [ProgressHUD showSuccess:@"清理成功" Interaction:NO];
        }];
    } else if ([model.title isEqualToString:@"图片质量"]) {
        CHSetUpDetailViewController *detailVC = [CHSetUpDetailViewController new];
        detailVC.mode = setupWithImage;
        detailVC.naviItemTitle = @"图片质量";
        detailVC.whenClickBack = ^(NSString *imageMode) {
            self.imageMode = imageMode;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:detailVC animated:NO];
    }
}

- (CGFloat)cacheSize
{
    if (!_cacheSize) {
        _cacheSize = [CHSaveCache floderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [CHSaveCache floderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [CHSaveCache floderSizeAtPath:NSTemporaryDirectory()];
    }
    return _cacheSize;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CHSetup" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _dataSource = [CHSetUpGroup mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _dataSource;
}

- (UIView *)logoutView
{
    if (!_logoutView) {
        _logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        _logoutView.backgroundColor = HexColor(0xffffff);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        label.text = @"退出登录";
        label.textColor = GLOBAL_COLOR;
        label.textAlignment = NSTextAlignmentCenter;
        [_logoutView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logOut)];
        _logoutView.userInteractionEnabled = YES;
        [_logoutView addGestureRecognizer:tap];
    }
    return _logoutView;
}

- (void)logOut
{
    [[UserModel defaultInstance] logout];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationMessage" object:nil userInfo:nil]; // 注册一个通知
    [ProgressHUD showSuccess:@"注销成功" Interaction:YES];
    //退出后要让其再进行登录
    [self showLogin];
    [[RCIM sharedRCIM] logout]; //断开与融云的连接，且不再接收信息
    [self ch_navigateBackTabbarItem:0];
}

#pragma mark - 注销通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
