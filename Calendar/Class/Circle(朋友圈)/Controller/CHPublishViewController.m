//
//  CHPublishViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPublishViewController.h"

#import "CHNormalButton.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "CHPublish.h"
#import "CHPublishView.h"
#import "CHPublishDetailViewController.h"
#import "CHMapSupportViewController.h"

@interface CHPublishViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *data;
@end

@implementation CHPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackCircleVC)];
    
    [self initTableView];
    
    [self initPublishButton];
}

//取消按钮的点击事件
- (void)clickBackCircleVC
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 发布正文
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, screenWithoutTopbar - 45) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, DDRealValueBy6s(220))];
//    view.backgroundColor = [UIColor redColor];
    CHPublishView *publishView = [[CHPublishView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, DDRealValueBy6s(192))];
    publishView.getData = ^(NSString *title) {
        NSLog(@"%@", title);
    };
    self.tableView.tableHeaderView = publishView;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
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
    CHPublish *publish = self.data[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Publish"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Publish"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.57 alpha:1];
    cell.textLabel.text = publish.title;
    cell.detailTextLabel.text = publish.subTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:publish.icon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { //我的位置
        CHMapSupportViewController *mapVC = [CHMapSupportViewController new];
        mapVC.whenAddressGet = ^(Address *address) {
            
        };
        [self.navigationController pushViewController:mapVC animated:NO];
    } else {
        NSLog(@"其余的");
    }
}

- (NSArray *)data
{
    if (!_data) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CHPublish" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _data = [CHPublish mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _data;
}


#pragma mark - 发布按钮
- (void)initPublishButton
{
    CHNormalButton *button = [CHNormalButton title:@"发布" titleColor:HexColor(0xffffff) font:16 aligment:NSTextAlignmentCenter backgroundcolor:GLOBAL_COLOR andBlock:^(CHNormalButton *button) {
        NSLog(@"发布");
    }];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(screenWithoutTopbar - 45 - tabbarHeight);
    }];
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
