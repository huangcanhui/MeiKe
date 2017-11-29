//
//  CHSetUpDetailViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSetUpDetailViewController.h"
#import "CHSettingModel.h"
#import "ProgressHUD.h"

static NSString *bundleID = @"setupDetail";
@interface CHSetUpDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *array;
/**
 * 设置图片模式
 */
@property (nonatomic, strong)CHSettingModel *settingModel;
@end

@implementation CHSetUpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = self.naviItemTitle;
    
    self.settingModel = [CHSettingModel defaultInstance];
    
    switch (self.mode) {
        case setupWithSecret: //隐私
            
            break;
        case setupWithMessage: //新消息通知
            
            break;
        case setupWithAdvince://意见反馈
            
            break;
        case setupWithHelp://帮助中心
            
            break;
        case setupWithImage://图片质量
        {
            self.array = @[@"智能模式", @"低质量(流量有限时使用)", @"高质量(适合WiFi下使用)"];
        }
            break;
            
        default:
            break;
    }
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
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
    }
    cell.textLabel.text = self.array[indexPath.section];
    if (self.settingModel.imageMode == indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            self.settingModel.imageMode = ImageModeAuto;
            [ProgressHUD showSuccess:@"已设置为智能模式"];
        }
            break;
        case 1:
        {
            self.settingModel.imageMode = ImageModeNormal;
            [ProgressHUD showSuccess:@"已设置为普通模式"];
        }
            break;
        case 2:
        {
            self.settingModel.imageMode = ImageModeHighQuality;
            [ProgressHUD showSuccess:@"已设置为高清模式"];
        }
            break;
            
        default:
            break;
    }
    [tableView reloadData];
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
