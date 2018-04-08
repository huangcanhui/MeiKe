//
//  CHFriend_DetailViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriend_DetailViewController.h"

#import "CHFriend_HeaderView.h"
#import "CHManager.h"
#import "ProgressHUD.h"

#import "CHFriend_AddMemoViewController.h"
#import "CHNavigationViewController.h"
#import "RCConversationViewController.h"

@interface CHFriend_DetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)CHFriend_HeaderView *headerView;
@property (nonatomic, strong)UIButton *chatButton;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *array;

@end

@implementation CHFriend_DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"好友信息";
    
    self.array = @[@"设置备注及圈子", @"个人圈子"];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"friend_operation"] style:UIBarButtonItemStyleDone target:self action:@selector(operateFriend)];
}

#pragma mark - 删除及拉黑操作
- (void)operateFriend
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认对%@进行操作", self.object.nickname] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *Action1 = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{
                                 @"user_id":self.object.id
                                 };
        [[CHManager manager] requestWithMethod:POST WithPath:CHReadConfig(@"friend_blackFriend_Url") WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
            [ProgressHUD showSuccess:@"已将好友拉黑"];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *Action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", CHReadConfig(@"friend_delete_Url"), self.object.id];
        [[CHManager manager] requestWithMethod:DELETE WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
            [ProgressHUD showSuccess:@"删除好友成功"];
            if (self.whenViewDisAppear) {
                self.whenViewDisAppear();
            }
            [self.navigationController popViewControllerAnimated:NO];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *Action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:Action1];
    [actionSheetController addAction:Action2];
    [actionSheetController addAction:Action3];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
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
        [_chatButton setTitle:@"发送消息" forState:UIControlStateNormal];
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
        cell.detailTextLabel.text = @"福建 厦门";
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.array[indexPath.row];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
    } else {
        CHFriend_AddMemoViewController *VC = [CHFriend_AddMemoViewController new];
        CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:VC];
        [self presentViewController:naVC animated:NO completion:^{
            
        }];
    }
}

- (void)chatWithOtherPerple
{
//    NSString *targetId = [NSString stringWithFormat:@"%@", self.object.id];
    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.object.nickname];
    chat.title = self.object.nickname;
    [self.navigationController pushViewController:chat animated:NO];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (self.whenViewDisAppear) {
        self.whenViewDisAppear();
    }
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
