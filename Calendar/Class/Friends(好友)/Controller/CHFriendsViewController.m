//
//  CHFriendsViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendsViewController.h"
#import "CHFriend_SearchViewController.h"
#import "CHNavigationViewController.h"

#import "CHFriend_SearchView.h"

static NSString *bundleID = @"FRIENDS";
@interface CHFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSMutableArray *charArrayM; //右侧的索引数据
@property (nonatomic, strong)NSArray *array;
/**
 * 搜索框
 */
@property (nonatomic, strong)CHFriend_SearchView *searchView;
@end

@implementation CHFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"好友";
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载
- (NSMutableArray *)charArrayM
{
    if (!_charArrayM) {
        self.charArrayM = [NSMutableArray array];
        [self.charArrayM addObject:[NSString stringWithFormat:@"#"]];
        for (char c = 'A'; c <= 'Z'; c++) {
            [self.charArrayM addObject:[NSString stringWithFormat:@"%c", c]];
        }
    }
    return _charArrayM;
}

- (CHFriend_SearchView *)searchView
{
    if (!_searchView) {
        _searchView = [CHFriend_SearchView searchViewWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 45) andBackGroundColor:[UIColor grayColor] andPlaceholder:@"搜索"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewClick)];
        _searchView.userInteractionEnabled = YES;
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}

- (void)searchViewClick
{
    CHFriend_SearchViewController *friendVC = [CHFriend_SearchViewController new];
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:friendVC];
    [self presentViewController:naVC animated:NO completion:nil];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, navigationHeight, 0);
        _tableView.backgroundColor = HexColor(0xffffff);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableHeaderView = self.searchView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.charArrayM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bundleID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bundleID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"friends_UserImage"];
    }
    cell.textLabel.text = @"哈哈";
    
    return cell;
}

//右侧的索引数据
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.charArrayM;
}

//跳转到指定的组
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for (NSString *character in self.charArrayM) {
        if ([character isEqualToString:title]) {
            return count;
        }
        count++;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.charArrayM[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
