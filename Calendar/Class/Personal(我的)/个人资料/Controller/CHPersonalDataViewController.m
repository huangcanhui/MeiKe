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
#import "CHManager.h"
#import "CHPersonalMessage.h"
#import "UIImageView+WebCache.h"
#import "CHNetString.h"

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
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    _arrayM = [NSMutableArray array]; //初始化
    
    [self requestData];
}

#pragma mark - 创建视图
- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
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
    if (indexPath.row == 0) {
        return 88;
    } else {
        return 44;
    }
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
  
    if (indexPath.row == 0 || indexPath.row == 3) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (indexPath.row == 0) {
            imageView.frame = CGRectMake(kScreenWidth - 100, 10, 60, 60);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:_arrayM[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"LOGO"]];
        } else {
            imageView.frame = CGRectMake(kScreenWidth - 60, 10, 25, 25);
            imageView.image = [UIImage imageNamed:@"Personal_Scancode"];
        }
        [cell.contentView addSubview:imageView];
    } else {
       cell.detailTextLabel.text = _arrayM[indexPath.row];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPersonalDataDetailViewController *detailVC = [CHPersonalDataDetailViewController new];
    switch (indexPath.row) {
        case 0: //昵称
        {
            detailVC.type = typeWithPicture;
            detailVC.text = @"个人头像";
            detailVC.data = _arrayM[indexPath.row];
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

- (void)requestData
{
    [[CHManager manager] requestWithMethod:GET WithPath:CHReadConfig(@"login_UserInfo_Url") WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        [_arrayM addObject:responseObject[@"data"][@"avatar"]];
        [_arrayM addObject:responseObject[@"data"][@"nickname"]];
        [_arrayM addObject:responseObject[@"data"][@"mobile"]];
        [_arrayM addObject:@"lala"];
        [_arrayM addObject:responseObject[@"data"][@"remark"]];
        [self initUI];
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

@end
