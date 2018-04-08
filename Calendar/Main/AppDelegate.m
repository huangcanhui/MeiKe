//
//  AppDelegate.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

#import "CHTabBarViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "IQKeyBoardManager/IQKeyboardManager.h"
#import <Contacts/Contacts.h>
//开启友盟分享以及分析、登录功能
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMSocialCore/UMSocialCore.h>
//介入通云通讯功能
#import <RongIMKit/RongIMKit.h>
#import "UserModel.h"
#import "UIViewController+CH.h"
#import "CHManager.h"


@interface AppDelegate ()<RCIMReceiveMessageDelegate>
@property(nonatomic, strong)User *user;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置主屏幕
    [self settingRootVCAndNeedLogin:YES];
    
    //设置高德key
    [self useMAMapKey];
    
    //键盘处理
    [[self class] setIQKeyBoard];
    
    //开启友盟统计
    [self startUMMobClick];
    
    //注册通知
    [self addNotification];
    
//    //连接融云通讯
//    [self connectRongCloudSDK];
    
    return YES;
}

#pragma mark - 设置主屏幕
- (void)settingRootVCAndNeedLogin:(BOOL)needLogin
{
    CHTabBarViewController *tab = [CHTabBarViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    //开启同步线程
    dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        if (needLogin && ![UserModel onLine]) {//如果需要登录且登录态为空时，调用
            [[UIApplication sharedApplication].keyWindow.rootViewController showLogin];
        }
    });
    dispatch_sync(queue, ^{
         [self connectRongCloudSDK];
    });
}

#pragma mark - 设置高德key
- (void)useMAMapKey
{
    [AMapServices sharedServices].apiKey = AMAPKEY;
}

#pragma mark - 注册中心
- (void)addNotification
{

}

#pragma mark - 键盘处理
+ (void)setIQKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; //控制整个功能都能使用
    manager.shouldResignOnTouchOutside = YES; //控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;// 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
}

#pragma mark - 开启友盟统计
- (void)startUMMobClick
{
    //配置友盟产品并进行统一的初始化
    [UMConfigure initWithAppkey:UMKEY channel:@"App Store"];
#ifdef DEBUG
    [UMConfigure setLogEnabled:YES]; //在测试模式下开启友盟日志显示
#else
    
#endif
    //开启友盟统计
    [MobClick setScenarioType:E_UM_NORMAL];
}

#pragma mark -开启融云
- (void)connectRongCloudSDK
{
    NSString *tokenUrl = CHReadConfig(@"rongCloud_token_Url");
    [[CHManager manager] requestWithMethod:GET WithPath:tokenUrl WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        //注册appkey
        [[RCIM sharedRCIM] initWithAppKey:RongCloudKey];
        //这是会话列表头像和会话页面头像
        [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
        //开启用户信息持久化
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        //开启输入状态监听
        [RCIM sharedRCIM].enableTypingStatus = YES;
        //开启消息撤回功能
        [RCIM sharedRCIM].enableMessageRecall = YES;
        //设置接收消息的代理
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        //连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:responseObject[@"data"][@"token"] success:^(NSString *userId) {
            NSLog(@"登录成功,当前登录的用户ID为:%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登录失败，错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
    } WithFailurBlock:^(NSError *error) {
        
    }];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
