//
//  IMChatViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "IMChatViewController.h"
#import "IQKeyBoardManager/IQKeyboardManager.h"

@interface IMChatViewController ()

@end

@implementation IMChatViewController

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUserInfo];
}

#pragma mark - 更新用户的信息
- (void)updateUserInfo
{
    if (![self.targetId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        NSLog(@"%@ %@", self.targetId, [RCIM sharedRCIM].currentUserInfo.userId);
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:[RCIM sharedRCIM].currentUserInfo.userId completion:^(RCUserInfo *userInfo) {
            NSLog(@"%@", userInfo);
        }];
    }
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
