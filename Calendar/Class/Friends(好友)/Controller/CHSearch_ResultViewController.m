//
//  CHSearch_ResultViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/19.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSearch_ResultViewController.h"
#import "CHFriend_HeaderView.h"

#import "LQPopUpView.h"
#import "CHManager.h"
#import "ProgressHUD.h"

#import "CHPrivate_notesViewController.h"

@interface CHSearch_ResultViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 头视图
 */
@property (nonatomic, strong)CHFriend_HeaderView *headerView;
/**
 * 添加好友按钮
 */
@property (nonatomic, strong)UIButton *chatButton;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *array;
@end

@implementation CHSearch_ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = _vctitle;
    
    self.array = @[@"个人圈子"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载
- (CHFriend_HeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [CHFriend_HeaderView headerView];
        _headerView.obj = self.object;
    }
    return _headerView;
}

- (UIButton *)chatButton
{
    if (!_chatButton) {
        _chatButton = [[UIButton alloc] initWithFrame:CGRectMake(16, kScreenHeight / 2 + 50, kScreenWidth - 32, 45)];
        _chatButton.backgroundColor = GLOBAL_COLOR;
        _chatButton.layer.masksToBounds = YES;
        _chatButton.layer.cornerRadius = 5;
        [_chatButton setTitle:@"添加好友到通讯录" forState:UIControlStateNormal];
        [_chatButton setTitleColor:HexColor(0xffffff) forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(chatWithOtherPerple) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        CHFriend_HeaderView *headerView = [CHFriend_HeaderView headerView];
        headerView.obj = self.object;
        _headerView = headerView;
        
        _tableView.tableHeaderView = _headerView;
        
        [_tableView addSubview:self.chatButton];
        _tableView.tableFooterView = [[UIView alloc] init];;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.bounces = NO; //关闭弹簧效果
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    } else {
        return self.array.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 32;
    } else {
        return 16;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detail"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"地区";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.object.province, self.object.city];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.array[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) { //个人圈子页面
        CHPrivate_notesViewController *privateVC = [CHPrivate_notesViewController new];
        privateVC.numId = self.object.id;
        [self.navigationController pushViewController:privateVC animated:YES];
    }
}

#pragma mark - 发送好友添加请求
- (void)chatWithOtherPerple
{
    LQPopUpView *popView = [[LQPopUpView alloc] initWithTitle:@"好友请求" message:@""];
    __weak typeof(LQPopUpView) *weakPopView = popView;
    [popView addTextFieldWithPlaceholder:@"备注说明" text:@"" secureEntry:NO];
    [popView addBtnWithTitle:@"取消" type:LQPopUpBtnStyleCancel handler:^{
        
    }];
    [popView addBtnWithTitle:@"发送" type:LQPopUpBtnStyleDefault handler:^{
        UITextField *textField = weakPopView.textFieldArray[0];
        NSDictionary *params = @{
                                 @"message":textField.text
                                 };
        NSString *path = [NSString stringWithFormat:@"%@/%@/apply", CHReadConfig(@"friend_sendRequest_Url"), self.object.id];
        [[CHManager manager] requestWithMethod:POST WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
            [ProgressHUD showSuccess:@"好友请求发送成功,请耐心等待回复"];
            [self.navigationController popViewControllerAnimated:YES];
        } WithFailurBlock:^(NSError *error) {
            
        }];
        
    }];
    [weakPopView showInView:self.view preferredStyle:LQPopUpViewStyleAlert];
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
