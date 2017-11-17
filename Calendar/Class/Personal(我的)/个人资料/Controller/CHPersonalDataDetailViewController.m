//
//  CHPersonalDataDetailViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/17.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHPersonalDataDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CHNormalButton.h"

#import "Masonry.h"

@interface CHPersonalDataDetailViewController ()
/**
 * 获取二维码
 */
@property (nonatomic, copy)NSString *scanCodeUrl;
@end

@implementation CHPersonalDataDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.text;
    
    switch (_type) {
        case typeWithPicture: //头像
            self.view.backgroundColor = HexColor(0x000000);
            [self createHeaderPicture];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PerData_shenglve"] style:UIBarButtonItemStyleDone target:self action:@selector(submitPicture)];
            break;
        case typeWithText: //文字输入
            [self createTextField];
            break;
        case typeWithScanCode: //二维码
            self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self getScanCode];
            break;
        default:
            break;
    }
}


#pragma mark - 创建头像的视图
- (void)createHeaderPicture
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}

- (void)submitPicture
{
    NSLog(@"头像上传");
}

#pragma mark - 创建文字输入
- (void)createTextField
{
    weakSelf(wself);
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [wself.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 40, 45));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
    }];
    
    CHNormalButton *button = [CHNormalButton title:@"确定" titleColor:HexColor(0xffffff) font:15 aligment:NSTextAlignmentCenter backgroundcolor:GLOBAL_COLOR andBlock:^(CHNormalButton *button) {
        wself.whenClickSubmitButton(textField.text);
        [wself.navigationController dismissViewControllerAnimated:NO completion:nil];
    }];
    [wself.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 50, 45));
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(textField.CH_bottom + 20);
    }];
    
}

#pragma mark - 获取二维码
- (void)getScanCode
{
    weakSelf(wself);
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.scanCodeUrl] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    [wself.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 40, kScreenWidth - 40));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
    }];
}

- (NSString *)scanCodeUrl
{
    if (!_scanCodeUrl) {
#warning 这边进行网络请求
        
    }
    return _scanCodeUrl;
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
