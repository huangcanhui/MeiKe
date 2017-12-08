//
//  CHAboutUsViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHAboutUsViewController.h"
#import "CHShareManager.h"
#import "CHNaviButton.h"

@interface CHAboutUsViewController ()
/**
 * 寻易Logo和名称
 */
@property (nonatomic, strong)UIView *logoView;
/**
 * 版本号
 */
@property (nonatomic, strong)UILabel *versionLabel;
/**
 * 下载二维码
 */
@property (nonatomic, strong)UIImageView *qrCodeImageView;
/**
 * 二维码解释
 */
@property (nonatomic, strong)UILabel *explainLabel;
/**
 * 公司地址
 */
@property (nonatomic, strong)UILabel *addressLabel;
@end

@implementation CHAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"关于我们";
    
    [self.view addSubview:self.logoView];
    
    [self.view addSubview:self.versionLabel];
    
    [self.view addSubview:self.qrCodeImageView];
    
    [self.view addSubview:self.explainLabel];
    
    [self.view addSubview:self.addressLabel];
    
    CHNaviButton *rightBtn = [CHNaviButton buttonwWithFrame:CGRectMake(0, 0, 32, 32) type:UIButtonTypeCustom andFont:12 andTitle:nil andTitleColor:nil imageName:@"activity_share" andBoolLabel:NO andTmepBlock:^(CHNaviButton *button) {
#warning 这边应该填写App Store的下载地址
        NSString *url = @"";
        [CHShareManager shareToFriendsViewController:self withTitle:@"信格" content:@"交朋友用信格" withUrl:url];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (UIView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 4, 50, kScreenWidth / 2, 50)];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        logo.image = [UIImage imageNamed:@"LOGO"];
        logo.layer.cornerRadius = 5;
        logo.layer.masksToBounds = YES;
        [_logoView addSubview:logo];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(logo.CH_right + 10, 10, kScreenWidth / 3, 25)];
        label.text = @"信格";
        label.textColor = [UIColor grayColor];
        label.textAlignment=  NSTextAlignmentLeft;
        label.adjustsFontSizeToFitWidth = YES;
        [_logoView addSubview:label];
    }
    return _logoView;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 4, _logoView.CH_bottom, kScreenWidth / 2, 30)];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //获取当前版本号
        _versionLabel.text = [NSString stringWithFormat:@"当前版本: V%@", version];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor = [UIColor grayColor];
    }
    return _versionLabel;
}

- (UIImageView *)qrCodeImageView
{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 4, _versionLabel.CH_bottom + 15, kScreenWidth / 2, kScreenWidth / 2)];
        _qrCodeImageView.image = [UIImage imageNamed:@"xunyiDownload"];
    }
    return _qrCodeImageView;
}

- (UILabel *)explainLabel
{
    if (!_explainLabel) {
        _explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _qrCodeImageView.CH_bottom + 20, kScreenWidth - 40, 18)];
        _explainLabel.text = @"扫描二维码， 您的朋友也可以下载信格客户端!";
        _explainLabel.textAlignment = NSTextAlignmentCenter;
        _explainLabel.adjustsFontSizeToFitWidth = YES;
        _explainLabel.textColor = [UIColor grayColor];
    }
    return _explainLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kScreenHeight - navigationHeight - tabbarHeight - 55, kScreenWidth - 40, 50)];
        _addressLabel.text = @"厦门市云梦星辰科技有限公司  版权所有\nCopyright ©2017 Xiamen Ymstars Technology Co,Ltd.All Rights Reserved.";
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _addressLabel;
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
