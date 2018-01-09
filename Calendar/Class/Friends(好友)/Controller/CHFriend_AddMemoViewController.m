//
//  CHFriend_AddMemoViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriend_AddMemoViewController.h"

@interface CHFriend_AddMemoViewController ()

@end

@implementation CHFriend_AddMemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置备注及圈子";
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

#pragma mark - 返回按钮的点击事件
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
