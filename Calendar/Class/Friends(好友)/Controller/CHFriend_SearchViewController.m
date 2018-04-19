//
//  CHFriend_SearchViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/1.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriend_SearchViewController.h"

#import "CHManager.h"
#import "MJExtension.h"
#import "FirendListObject.h"
#import "UIImageView+WebCache.h"
#import "CHNetString.h"

#import "CHSearch_ResultViewController.h"

@interface CHFriend_SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
/**
 * UISearchBar
 */
@property (nonatomic, strong)UISearchBar *searchBar;
/**
 * 未查找到好友
 */
@property (nonatomic, strong)UILabel *unsearchLabel;
/**
 * 数组
 */
@property (nonatomic, strong)NSArray *searchArray;
/**
 * 好友视图列表
 */
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation CHFriend_SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchArray = [NSArray array];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.titleView = self.searchBar;
    
    [self.view addSubview:self.tableView];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        
        _searchBar.placeholder = @"请输入手机号或者用户名进行查找";
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        //将英文的cancle转变成中文“取消”
        for (id cancleBtn in [_searchBar.subviews[0]subviews]) {
            if ([cancleBtn isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)cancleBtn;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
            }
        }
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    searchBar.text = @"取消";
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *path = CHReadConfig(@"friends_searchRequest_Url");
    NSDictionary *params = @{
                             @"key":searchBar.text
                             };
    [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
        if ([responseObject[@"data"] count] == 0) { //未查找到好友
            self.searchArray = [NSArray array];
            [self.tableView reloadData]; //将搜索到的结果置空
            [self.view addSubview:self.unsearchLabel];
        } else {
            [self.unsearchLabel removeFromSuperview]; //移除掉未查找到好友的视图
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                FirendListObject *model = [FirendListObject mj_objectWithKeyValues:dict];
                [arrayM addObject:model];
            }
            self.searchArray = [arrayM copy];
            [self.tableView reloadData];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

- (UILabel *)unsearchLabel
{
    if (!_unsearchLabel) {
        _unsearchLabel = [UILabel new];
        _unsearchLabel.text = @"未匹配到您查找的好友";
        _unsearchLabel.frame = CGRectMake(0, 100, kScreenWidth, 200);
        _unsearchLabel.font = [UIFont systemFontOfSize:18];
        _unsearchLabel.textColor = [UIColor grayColor];
        _unsearchLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unsearchLabel;
}

#pragma mark - UITableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark UITableView.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"search"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FirendListObject *model = self.searchArray[indexPath.row];
    cell.textLabel.text = model.remark;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:model.avatar]] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHSearch_ResultViewController *resultVc = [CHSearch_ResultViewController new];
    FirendListObject *model = self.searchArray[indexPath.row];
    resultVc.vctitle = @"搜索结果";
    resultVc.object = model;
    [self.navigationController pushViewController:resultVc animated:NO];
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
