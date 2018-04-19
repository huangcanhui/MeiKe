//
//  CHPrivate_notesViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/19.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPrivate_notesViewController.h"

@interface CHPrivate_notesViewController ()

@end

@implementation CHPrivate_notesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"个人圈子";
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
