//
//  CHAdd_CommunityViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/2.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHAdd_CommunityViewController.h"

#import "CHNormalButton.h"
#import "Masonry.h"
#import "CHManager.h"
#import "ProgressHUD.h"
#import "FriendListModel.h"
#import "MJExtension.h"

#import "LQPopUpView.h"

@interface CHAdd_CommunityViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITextField
 */
@property (nonatomic, strong)UITextField *textField;
/**
 * 创建圈子按钮
 */
@property (nonatomic, strong)UIButton *communityButton;
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *data;
@end

@implementation CHAdd_CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加圈子";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.textField];
    
    [self.view addSubview:self.tableView];
    
    [self createCommunityButton];
}

#pragma mark - UITextField
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, kScreenWidth - 16, 48)];
        _textField.placeholder = @"请输入名称创建圈子";
        [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    }
    return _textField;
}

#pragma mark - UITableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.textField.CH_bottom + 8, kScreenWidth, screenWithoutTopbar - self.textField.CH_height - 48 - tabbarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark UITableView.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"已创建的圈子";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Huang"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Huang"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FriendListModel *list = self.data[indexPath.row];
    cell.textLabel.text = list.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        FriendListModel *list = self.data[indexPath.row];
        LQPopUpView *popView = [[LQPopUpView alloc] initWithTitle:@"提示" message:@"请输入新的圈子名称"];
        __weak typeof(LQPopUpView) *weakPopUpView = popView;
        [popView addTextFieldWithPlaceholder:@"" text:list.name secureEntry:NO];
        [popView addBtnWithTitle:@"取消" type:LQPopUpBtnStyleCancel handler:^{
            
        }];
        [popView addBtnWithTitle:@"修改" type:LQPopUpBtnStyleDefault handler:^{
            NSString *url = CHReadConfig(@"community_List_Url");
            NSString *path = [NSString stringWithFormat:@"%@/%@", url, list.id];
            UITextField *textField = weakPopUpView.textFieldArray[0];
            NSDictionary *params = @{
                                     @"name":textField.text
                                     };
            [[CHManager manager] requestWithMethod:PUT WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.data = nil;
                [self.tableView reloadData];
            } WithFailurBlock:^(NSError *error) {
                
            }];
        }];
        
        [popView showInView:self.view preferredStyle:LQPopUpViewStyleAlert];
    }];
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *url = CHReadConfig(@"community_List_Url");
        FriendListModel *list = self.data[indexPath.row];
        NSString *path = [NSString stringWithFormat:@"%@/%@", url, list.id];
        [[CHManager manager] requestWithMethod:DELETE WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_data];
            [arrayM removeObjectAtIndex:indexPath.row];
            _data = [arrayM copy];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; //删除列表中的数据
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }];
    
    return @[editAction, deleteAction];
}

////实现这个方法，可以实现置顶的功能
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//
//}

#pragma mark - 发布按钮
- (void)createCommunityButton
{
    CHNormalButton *button = [CHNormalButton title:@"创建" titleColor:HexColor(0xffffff) font:16 aligment:NSTextAlignmentCenter backgroundcolor:GLOBAL_COLOR andBlock:^(CHNormalButton *button) {
        NSString *url = CHReadConfig(@"community_List_Url");
        NSDictionary *params = @{
                                 @"name":self.textField.text
                                 };
        [[CHManager manager] requestWithMethod:POST WithPath:url WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
            [ProgressHUD showSuccess:@"圈子创建成功!"];
            [self.tableView reloadData];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(screenWithoutTopbar - 45 - tabbarHeight);
    }];
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
            [self.tableView reloadData];
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }
    return _data;
}

@end
