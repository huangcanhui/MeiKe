//
//  IMListViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/3.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "IMListViewController.h"
#import "IMChatViewController.h"
#import "CHBarButtonItem.h"
#import "KxMenu.h"

@interface IMListViewController ()<RCIMUserInfoDataSource>

@end

@implementation IMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"会话列表";
    
    CHBarButtonItem *rightButton = [[CHBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"add"] imageViewFrame:CGRectMake(0, 0, 25, 25) buttonTitle:nil titleColor:nil titleFrame:CGRectZero buttonFrame:CGRectMake(0, 0, 25, 25) target:self action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self settingIMSDKViewlist];
}

#pragma mark - 右上角按钮的点击事件
- (void)showMenu:(UIButton *)sender
{
   NSArray *memuItems = @[
                          [KxMenuItem menuItem:@"添加好友" image:[UIImage imageNamed:@"Home_AddFriend"] target:self action:@selector(pushAddFriend:)],
                          [KxMenuItem menuItem:@"扫一扫" image:[UIImage imageNamed:@"Home_ScanCode"] target:self action:@selector(pushScanCode:)],
                          [KxMenuItem menuItem:@"我的二维码" image:[UIImage imageNamed:@"Home_MyselfCode"] target:self action:@selector(pushMyselfCode:)]
                          ];
    
//    UIBarButtonItem *rightbarButton = self.tabBarController.navigationItem.rightBarButtonItems[0];
    UIBarButtonItem *rightbarButton = self.navigationItem.rightBarButtonItem;
    
    CGRect targetFrame = rightbarButton.customView.frame;
    CGFloat offset = [UIApplication sharedApplication].statusBarFrame.size.height > 20 ? 54 : 15;
    targetFrame.origin.y = targetFrame.origin.y + offset;
    if (IOS_FSystenVersion >= 11.0) {
        targetFrame.origin.x = self.view.bounds.size.width - targetFrame.size.width - 17;
    }
    [KxMenu setTintColor:HexColor(0x000000)];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview fromRect:targetFrame menuItems:memuItems];
}

#pragma mark 右上角弹出层的点击事件
- (void)pushAddFriend:(id)sender
{
    NSLog(@"添加");
}

- (void)pushScanCode:(id)sender
{
    NSLog(@"扫一扫");
}

- (void)pushMyselfCode:(id)sender
{
    NSLog(@"我的二维码");
}

#pragma mark - 设置融云会话列表
- (void)settingIMSDKViewlist
{
    //设置需要显示那些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    IMChatViewController *imVC = [[IMChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    imVC.title = model.targetId;
    [self.navigationController pushViewController:imVC animated:YES];
//    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
//    chat.title = model.targetId;
//    [self.navigationController pushViewController:chat animated:NO];
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
