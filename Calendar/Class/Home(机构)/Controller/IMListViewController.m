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
#import "CHOrganizationListView.h"
#import "UITabBarItem+CHBadge.h"

#import "CHFriend_SearchViewController.h"
#import "CHScanCodeViewController.h"
#import "CHNavigationViewController.h"

#import "CHHomeViewController.h"
#import "CHHomeDetailViewController.h"

@interface IMListViewController ()
/**
 * 机构列表
 */
@property (nonatomic, strong)CHOrganizationListView *organizationView;

- (void)updateBadgeValueForTabBarItem;

@end

@implementation IMListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置需要显示那些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置需要显示那些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self notifyUpdateUnreadMessageCount];
    //设置需要显示那些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
}

- (void)notifyUpdateUnreadMessageCount
{
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem
{
    weakSelf(wself);
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        if (count > 0) {
            [wself.tabBarController.tabBar.items[0] showBadge];
        } else {
            [wself.tabBarController.tabBar.items[0] hidenBadge];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"会话列表";
    
    CHBarButtonItem *rightButton = [[CHBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"add"] imageViewFrame:CGRectMake(0, 0, 25, 25) buttonTitle:nil titleColor:nil titleFrame:CGRectZero buttonFrame:CGRectMake(0, 0, 25, 25) target:self action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.conversationListTableView.tableHeaderView = self.organizationView;
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
}

- (CHOrganizationListView *)organizationView
{
    if (!_organizationView) {
        _organizationView = [[CHOrganizationListView alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 100)];
        _organizationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        weakSelf(wself);
        _organizationView.enterOrganizationList = ^(NSNumber *tag, NSString *name) {
            if ([tag isEqualToNumber:@0]) { //查看更多机构页面
                CHHomeViewController *homeVC = [CHHomeViewController new];
                [wself.navigationController pushViewController:homeVC animated:NO];
            } else {
                CHHomeDetailViewController *detailVC = [CHHomeDetailViewController new];
                detailVC.origanizationID = tag;
                detailVC.simple_name = name;
                [wself.navigationController pushViewController:detailVC animated:NO];
            }
        };
    }
    return _organizationView;
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
    CHFriend_SearchViewController *searchVC = [CHFriend_SearchViewController new];
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:searchVC];
    [self presentViewController:naVC animated:NO completion:^{
        
    }];
}

- (void)pushScanCode:(id)sender
{
    CHScanCodeViewController *scanVC = [CHScanCodeViewController new];
    [self.navigationController pushViewController:scanVC animated:NO];
}

- (void)pushMyselfCode:(id)sender
{
    NSLog(@"我的二维码");
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    IMChatViewController *imVC = [[IMChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    imVC.title = model.conversationTitle;
    [self.navigationController pushViewController:imVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
