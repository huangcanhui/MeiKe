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
#import "Masonry.h"
#import "CHBorderButton.h"
#import "UILabel+CH.h"
#import "CHNormalButton.h"

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
/**
 * UIView
 */
@property (nonatomic, strong)UIView *advinceView;
/**
 * UITextView
 */
@property (nonatomic, strong)UITextView *textView;
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
        {
            self.array = @[@"朋友圈", @"闪退/卡顿", @"通讯录", @"其他"];
            [self.view addSubview:self.advinceView];
            [self initAdvanceView];
        }
            break;
        case setupWithHelp://帮助中心
            
            break;
        case setupWithImage://图片质量
        {
            self.array = @[@"智能模式", @"低质量(流量有限时使用)", @"高质量(适合WiFi下使用)"];
            [self.view addSubview:self.tableView];
        }
            break;
            
        default:
            break;
    }
    
    
}

/******************************** 意见反馈 ******************************************************/
#pragma mark - 意见反馈部分
- (void)initAdvanceView
{
    CGFloat width = [UILabel getWidthWithTitle:@"反馈类型" font:[UIFont systemFontOfSize:13]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.advinceView.CH_height / 4, width, self.advinceView.CH_height / 2)];
    label.text = @"反馈类型";
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    CGFloat btnW = (kScreenWidth - 20 - label.CH_width) / self.array.count;
    for (int i = 0; i < self.array.count; i++) {
        CHBorderButton *button = [[CHBorderButton alloc] initWithFrame:CGRectMake(label.CH_right + 10 + btnW * i, self.advinceView.CH_height / 4, btnW - 10, self.advinceView.CH_height / 2)];
        [button setTitle:self.array[i] forState:UIControlStateNormal];
        [button setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
        button.borderColor = [UIColor groupTableViewBackgroundColor];
        button.tag = 100 + i;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button addTarget:self action:@selector(advinceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.advinceView addSubview:button];
    }
    
    //横线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.advinceView.CH_height - 4, kScreenWidth, 4)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.advinceView addSubview:view];
    
    [self.view addSubview:self.textView];
    
    CHNormalButton *subButton = [CHNormalButton title:@"提交" titleColor:HexColor(0xffffff) font:15 aligment:NSTextAlignmentCenter backgroundcolor:GLOBAL_COLOR andBlock:^(CHNormalButton *button) {
#warning 这边需要进行一次网络请求
        NSLog(@"点击提交");
    }];
    subButton.layer.cornerRadius = 5;
    subButton.layer.masksToBounds = YES;
    [self.view addSubview:subButton];
    [subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 20, 50));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.textView.CH_bottom + 10);
    }];
}

- (void)advinceButtonClick:(CHBorderButton *)button
{
    [self getOperationWithButtonTag:button.tag];
    for (UIView *view in self.advinceView.subviews) {
        if ([view isKindOfClass:[CHBorderButton class]]) {
            if (view.tag == button.tag) {
                ((CHBorderButton *)view).selected = YES;
                ((CHBorderButton *)view).borderColor = [UIColor blueColor];
            } else {
                ((CHBorderButton *)view).selected = NO;
                ((CHBorderButton *)view).borderColor = [UIColor groupTableViewBackgroundColor];
            }
        }
    }
}

- (void)getOperationWithButtonTag:(NSInteger)tag
{
    //获取用户选中的类型
}

#pragma mark 懒加载
- (UIView *)advinceView
{
    if (!_advinceView) {
        _advinceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 9)];
        _advinceView.backgroundColor = HexColor(0xffffff);
    }
    return _advinceView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.advinceView.CH_bottom + 5, kScreenWidth - 20, 180)];
        _textView.text = @"您的意见是我们前进的最大动力!";
        _textView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 5;
    }
    return _textView;
}

/******************************** 图片质量 ******************************************************/
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
            if (self.whenClickBack) {
                self.whenClickBack(@"智能模式");
            }
            [ProgressHUD showSuccess:@"已设置为智能模式"];
        }
            break;
        case 1:
        {
            self.settingModel.imageMode = ImageModeNormal;
            if (self.whenClickBack) {
                self.whenClickBack(@"普通模式");
            }
            [ProgressHUD showSuccess:@"已设置为普通模式"];
        }
            break;
        case 2:
        {
            self.settingModel.imageMode = ImageModeHighQuality;
            if (self.whenClickBack) {
                self.whenClickBack(@"高清模式");
            }
            [ProgressHUD showSuccess:@"已设置为高清模式"];
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
