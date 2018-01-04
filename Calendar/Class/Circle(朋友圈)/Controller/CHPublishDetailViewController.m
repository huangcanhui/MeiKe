//
//  CHPublishDetailViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPublishDetailViewController.h"

#import "ProgressHUD.h"
#import "CHManager.h"
#import "FriendListModel.h"
#import "MJExtension.h"

#import "CHAdd_CommunityViewController.h"

@interface CHPublishDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * 视图隐私
 */
@property (nonatomic, strong)UIView *privateView;
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *data;
/**
 * 是否私有
 */
@property (nonatomic, assign)BOOL isPrivate;
/**
 * 圈子id
 */
@property (nonatomic, strong)NSNumber *numberID;
/**
 * 选中
 */
@property (nonatomic, assign)NSIndexPath *indexPath;
/**
 * 提示添加圈子视图
 */
@property (nonatomic, strong)UIView *addFriendView;
@end

@implementation CHPublishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布圈子";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.privateView];
    
    self.isPrivate = YES; //初始化
    
    if (self.isPrivate == YES) {
        [self.view addSubview:self.tableView];
    }

}

#pragma mark - 懒加载
- (UIView *)privateView
{
    if (!_privateView) {
        _privateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        _privateView.backgroundColor = HexColor(0xffffff);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, kScreenWidth / 2, 35)];
        label.text = @"是否仅自己可见";
        label.textColor = HexColor(0x000000);
        label.textAlignment = NSTextAlignmentLeft;
        [_privateView addSubview:label];
        
        UISwitch *oneSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 8 - 80, 8, 0, 0)];
        oneSwitch.on = YES; //默认开启
        [oneSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        [_privateView addSubview:oneSwitch];
    }
    return _privateView;
}

- (void)switchValueChange:(UISwitch *)sender
{
    if (sender.on) { //开启
        self.isPrivate = YES;
        [self.view addSubview:self.tableView];
    } else { //关闭
        self.isPrivate = NO;
        [self.tableView removeFromSuperview];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _privateView.CH_bottom + 8, kScreenWidth, screenWithoutTopbar - _privateView.CH_height) style:UITableViewStyleGrouped];
        
        weakSelf(wself);
        
        _tableView.delegate = wself;
        _tableView.dataSource = wself;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIView *)addFriendView
{
    if (!_addFriendView) {
        _addFriendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:_addFriendView.bounds];
#warning 这是测试的时候，把这段代码注释了
//        if (self.data.count == 0) {
//            [button setTitle:@"您还没有圈子，点我赶紧添加一个吧!" forState:UIControlStateNormal];
//            [button setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(addNewFriendList) forControlEvents:UIControlEventTouchUpInside];
//        } else {
//            [button setTitle:@"我拥有的圈子" forState:UIControlStateNormal];
//            [button setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
//            button.titleLabel.textAlignment = NSTextAlignmentLeft;
//        }
        [button setTitle:@"您还没有圈子，点我赶紧添加一个吧!" forState:UIControlStateNormal];
        [button setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addNewFriendList) forControlEvents:UIControlEventTouchUpInside];
        [_addFriendView addSubview:button];
    }
    return _addFriendView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publish"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"publish"];
    }
    FriendListModel *list = self.data[indexPath.row];
    cell.textLabel.text = list.name;
    if (indexPath.row == self.indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    FriendListModel *list = self.data[indexPath.row];
    self.numberID = list.id;
    
    [self.tableView reloadData];
}

#pragma mark - 保存按钮的点击事件
- (void)saveData
{
    //先判断是否选择了圈子
    if (self.numberID == nil && self.isPrivate == YES) { //未选择发布的圈子
        [ProgressHUD showError:@"您还未选择发布的圈子"];
    } else {
        if (self.getData) {
            self.getData(self.isPrivate, self.numberID);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 添加圈子
- (void)addNewFriendList
{
    CHAdd_CommunityViewController *addVC = [CHAdd_CommunityViewController new];
    
    [self.navigationController pushViewController:addVC animated:NO];
}

#pragma mark - 数据源
- (NSArray *)data
{
    if (!_data) {
       NSString *url = CHReadConfig(@"community_List_Url");
        [[CHManager manager] requestWithMethod:GET WithPath:url WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                FriendListModel *list = [FriendListModel mj_objectWithKeyValues:dict];
                [arrayM addObject:list];
            }
            _data = [arrayM copy];
            _tableView.tableHeaderView = self.addFriendView;
            [self.tableView reloadData];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }
    return _data;
}

@end
