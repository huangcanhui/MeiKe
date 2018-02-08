//
//  CHUserView.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHUserView.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "CHNetString.h"

@interface CHUserView ()
/**
 * 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
/**
 * 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *headName;
/**
 * 点击的手势
 */
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@end

@implementation CHUserView


+ (instancetype)headerView
{
    CHUserView *view = [[[NSBundle mainBundle] loadNibNamed:@"CHUserView" owner:nil options:nil] lastObject];
    //UI
    [view initView];
    
    return view;
}

- (void)initView
{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
}

- (void)clickTap:(UITapGestureRecognizer *)tap
{
    if (_whenLoginBtnClick) {
        _whenLoginBtnClick();
    }
}

- (void)setUser:(User *)user
{
    _user = user;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [self addGestureRecognizer:_tap]; //添加手势
    if ([UserModel onLine]) { //监测用户是否已经登录
        [self blankData];
    } else {
        self.headName.text = @"点击此处进行登录";
        self.headIcon.image = [UIImage imageNamed:@"Personal_BackHead"];
    }
}

- (void)blankData
{
    [[UserModel defaultInstance] info];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo:) name:@"GETUSERINFO" object:nil];
}

- (void)getUserInfo:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification object];
    UserInfo *userInfo = dictionary[@"UserInfo"];
    if (![userInfo.avatar isEqual:@""]) {
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:userInfo.avatar]] placeholderImage:[UIImage imageNamed:@"Personal_BackHead"]];
    }
    
    self.headName.text = [NSString stringWithFormat:@"您好,%@", userInfo.nickname];
    self.headName.adjustsFontSizeToFitWidth = YES;
}

@end
