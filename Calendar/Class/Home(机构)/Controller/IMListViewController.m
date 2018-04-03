//
//  IMListViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/3.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "IMListViewController.h"

@interface IMListViewController ()

@end

@implementation IMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"会话列表";
    
    [self initLabel];
    
    [self settingIMSDKViewlist];
}

#pragma mark - 其余的列表
- (void)initLabel
{
}

#pragma mark - 设置融云会话列表
- (void)settingIMSDKViewlist
{
    //设置需要显示那些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_SYSTEM), @(ConversationType_PRIVATE), @(ConversationType_APPSERVICE)]];
    //设置需要将那些类型的会话在会话列表中聚合
    [self setCollectionConversationType:@[@(ConversationType_APPSERVICE)]];
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
