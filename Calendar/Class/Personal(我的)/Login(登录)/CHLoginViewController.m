//
//  CHLoginViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/15.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHLoginViewController.h"
#import "ProgressHUD.h"
#import "CHManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "CHWebViewController.h"

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
/**
 * 勾选用户须知
 */
@property (weak, nonatomic) IBOutlet UIImageView *checkProtocol;
/**
 * 判断用户是否勾选了用户须知
 */
@property (assign, nonatomic)BOOL isCheck;
/**
 * 中间键
 */
@property (assign, nonatomic)int count;

@end

@implementation CHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickBack)];
    
    //初始化
    self.isCheck = NO; //默认用户未勾选
    self.count = 0;
    
    [self initUI];
}

- (void)initUI
{
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolCheckButton:)];
    self.checkProtocol.userInteractionEnabled = YES;
    [self.checkProtocol addGestureRecognizer:tap];
}

- (void)protocolCheckButton:(UITapGestureRecognizer *)tap
{
    self.count ++;
    if (self.count % 2 == 0) { //未选中，取余法
        self.isCheck = NO;
        self.checkProtocol.image = nil;
        self.checkProtocol.image = [UIImage imageNamed:@"loginCircle"];
    } else {
        self.isCheck = YES;
        self.checkProtocol.image = [UIImage imageNamed:@"loginCircle_active"];
    }
    NSLog(@"%d", self.count);
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
//        [SVProgressHUD showErrorWithStatus:@"手机号不合法"];
        [ProgressHUD showError:@"手机号不合法" Interaction:NO];
    }
}

/**
 * 获取验证码
 */
- (void)getSmsCode:(NSString *)mobile
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:mobile zone:@"86" result:^(NSError *error) {
        if (error) {
//            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
            [ProgressHUD showError:@"验证码获取失败" Interaction:NO];
        } else {
//            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功，请查收"];
            [ProgressHUD showSuccess:@"验证码发送成功，请查收" Interaction:NO];
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
 * 用户须知
 */
- (IBAction)companyProtocol:(id)sender {
    CHWebViewController *webView = [CHWebViewController new];
    webView.title = @"用户须知";
#warning 这个地方要更改
    webView.webString = @"https://www.baidu.com";
    [self.navigationController pushViewController:webView animated:NO];
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
//        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        [ProgressHUD showError:@"用户名不能为空" Interaction:NO];
        return NO;
    }
    
    if (mobile.length != 11) {
//        [SVProgressHUD showErrorWithStatus:@"用户名为11位的手机号"];
        [ProgressHUD showError:@"用户名为11位的手机号" Interaction:NO];
        return NO;
    }
    
    if (self.isCheck == NO) {
//        [SVProgressHUD showErrorWithStatus:@"请先阅读用户须知"];
        [ProgressHUD showError:@"请先阅读用户须知" Interaction:NO];
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
