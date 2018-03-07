//
//  CHHomeViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/3/7.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHHomeViewController.h"

#import "CHHomeDetailViewController.h"

@interface CHHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *dataSource;
@end

@implementation CHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"机构列表";
    
    [self setOriganizationTable];
}

#pragma mark - 创建机构列表
- (void)setOriganizationTable
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.contentInset = UIEdgeInsetsMake(16, 0, 25, 0);
    
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
}

#pragma mark UITableView.delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { //着重展示的机构列表
        return 98;
    } else {
        return 49;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"我关注的机构";
    } else {
        return @"其他机构列表";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Origanization"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Origanization"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"LOGO"];
    cell.textLabel.text = @"我的机构名称";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHHomeDetailViewController *detailVC = [CHHomeDetailViewController new];
    if (indexPath.section == 0) { //不需要出现置顶的按钮
        detailVC.isStick = NO;
    } else {
        detailVC.isStick = YES;
    }
    detailVC.getNewOriganization = ^{
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:detailVC animated:NO];
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
