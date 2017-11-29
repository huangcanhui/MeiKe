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
@end

@implementation CHSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"设置";
    
    [self.view addSubview:self.tableView];
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
    cell.detailTextLabel.text = model.subtitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
