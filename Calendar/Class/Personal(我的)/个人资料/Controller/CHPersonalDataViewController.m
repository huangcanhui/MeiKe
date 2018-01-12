//
//  CHPersonalDataViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPersonalDataViewController.h"
#import "CHPersonalData.h"
#import "MJExtension.h"

#import "CHPersonalDataDetailViewController.h"

static NSString *cellID = @"PersonalData";
@interface CHPersonalDataViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *data; //这个用来存放plist文件读取到的数据
@property (nonatomic, strong)NSMutableArray *arrayM; //这个用来存放获取到的用户数据

@end

@implementation CHPersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    _arrayM = [NSMutableArray array]; //初始化
    
    [self initUI];
}

#pragma mark - 创建视图
- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中的样式
    }
    CHPersonalData *data = _data[indexPath.row];
    cell.textLabel.text = data.title;
//    cell.detailTextLabel.text = _arrayM[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPersonalDataDetailViewController *detailVC = [CHPersonalDataDetailViewController new];
    switch (indexPath.row) {
        case 0: //昵称
        {
            detailVC.type = typeWithText;
            detailVC.text = @"修改昵称";
            detailVC.whenClickSubmitButton = ^(NSString *string) {
                [_arrayM replaceObjectAtIndex:indexPath.row + 1 withObject:string];
                [self.tableView reloadData];
            };
        }
            break;
        case 1:
            
            break;
        case 2:
        {
            detailVC.type = typeWithScanCode;
//            detailVC.num =  //传递用户的ID
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:detailVC animated:NO];
}

#pragma mark - 懒加载
- (NSArray *)data
{
    if (!_data) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PersonalData" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _data = [CHPersonalData mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _data;
}

@end
