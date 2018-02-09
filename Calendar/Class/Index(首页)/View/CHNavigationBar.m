//
//  CHNavigationBar.m
//  Calendar
//
//  Created by huangcanhui on 2018/2/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHNavigationBar.h"

@implementation CHNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    //让导航栏成为透明
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.barTintColor = [UIColor clearColor];
    self.translucent = YES;
    self.shadowImage = [UIImage new];
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:@"黄灿辉"];
    self.items = @[self.navigationItem];
}

@end
