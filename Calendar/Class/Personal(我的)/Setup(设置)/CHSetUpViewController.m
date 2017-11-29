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

#import "CHSetUpDetailViewController.h"

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
@end

@implementation CHSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"设置";
    
    [self.view addSubview:self.tableView];
    
    self.cacheString = self.cacheSize > 1 ? [NSString stringWithFormat:@"缓存:%.2fM", self.cacheSize] : [NSString stringWithFormat:@"缓存:%.2fK", self.cacheSize * 1024.0];

}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHSetUpGroup *group = self.dataSource[indexPath.section];
    CHSetUpModel *model = group.project[indexPath.row];
    if ([model.title isEqualToString:@"隐私"]) {
        
    } else if ([model.title isEqualToString:@"新消息通知"]) {
        
    } else if ([model.title isEqualToString:@"意见反馈"]) {
        
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

@end
