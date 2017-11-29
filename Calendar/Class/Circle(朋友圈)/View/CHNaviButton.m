//
//  CHNaviButton.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHNaviButton.h"

@implementation CHNaviButton

+ (CHNaviButton *)buttonwWithFrame:(CGRect)frame type:(UIButtonType)type andFont:(int)font andTitle:(NSString *)title andTitleColor:(UIColor *)color imageName:(NSString *)imageName andBoolLabel:(BOOL)boolLabel andTmepBlock:(naviBlock)block
{
    CHNaviButton *button = [CHNaviButton buttonWithType:type];
    button.frame = frame;
    if (boolLabel == YES) { //需要手动填写文字
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:font];
        button.imageView.contentMode = UIViewContentModeCenter;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [button addTarget:button action:@selector(clickNaviBarItems:) forControlEvents:UIControlEventTouchUpInside];
    button.tempBlock = block;
    return button;
}

- (void)clickNaviBarItems:(CHNaviButton *)button
{
    button.tempBlock(button);
}

@end
