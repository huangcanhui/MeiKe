//
//  CHFriendsViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHFriendsViewController.h"

@interface CHFriendsViewController ()

@end

@implementation CHFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"好友";
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
