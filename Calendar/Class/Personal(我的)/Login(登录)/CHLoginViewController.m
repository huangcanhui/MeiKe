//
//  CHLoginViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/15.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHLoginViewController.h"
#import "SVProgressHUD.h"
#import "CHManager.h"
#import <SMS_SDK/SMSSDK.h>

@interface CHLoginViewController ()
{
    NSUInteger timeLeft; //倒计时时间
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 * 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *Mobile;
/**
 * 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
/**
 * 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/**
 * 验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *smsButton;

@end

@implementation CHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(clickBack)];
    
    [self initUI];
}

- (void)initUI
{
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)clickBack
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 获取验证码
- (IBAction)getVercode:(id)sender {
    //验证手机号是否合法
    if ([self.Mobile.text validPhone]) {
        [self getSmsCode:self.Mobile.text];
    } else { //手机号不合法
        [SVProgressHUD showErrorWithStatus:@"手机号不合法"];
    }
}

/**
 * 获取验证码
 */
- (void)getSmsCode:(NSString *)mobile
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:mobile zone:@"86" result:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功，请查收"];
            self.smsButton.enabled = NO; //发送验证码禁止点击
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }
    }];
}

- (void)countDown
{
    timeLeft -= 1;
    if (timeLeft <= 0) {
        timeLeft = 0;
        [self unlockCodeBtn];
    } else {
        [self.smsButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", timeLeft] forState:UIControlStateDisabled];
        [self.smsButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
}

- (void)unlockCodeBtn
{
    self.smsButton.enabled = YES;
    [self.smsButton setTitleColor:GLOBAL_COLOR forState:UIControlStateNormal];
    [timer invalidate];
    timer = nil;
}

/**
 * 登录的点击事件
 */
- (IBAction)loginButton:(id)sender {
    [self loginWithMobile:self.Mobile.text andVerCode:self.verificationCode.text];
}

- (void)loginWithMobile:(NSString *)mobile andVerCode:(NSString *)code
{
    if ([self verityMobile:mobile andCode:code]) {
        //登录
        [self.view endEditing:YES];
        [self loginWithUrlInMobile:mobile andCode:code];
    }
}

- (BOOL)verityMobile:(NSString *)mobile andCode:(NSString *)code
{
    if ([NSString isBlank:mobile]) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return NO;
    }
    
    if (mobile.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"用户名为11位的手机号"];
        return NO;
    }
    return YES;
}

/**
 * 微信的登录方式
 */
- (IBAction)loginWithWeChat:(id)sender {
}

/**
 * qq的登录方式
 */
- (IBAction)loginWithQQ:(id)sender {
}

- (void)loginWithUrlInMobile:(NSString *)mobile andCode:(NSString *)code
{
    
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
