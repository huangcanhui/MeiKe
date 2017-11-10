//
//  CHNormalButton.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHNormalButton.h"

@implementation CHNormalButton

+ (CHNormalButton *)title:(NSString *)title titleColor:(UIColor *)color font:(CGFloat)font aligment:(NSTextAlignment)aligment backgroundcolor:(UIColor *)backcolor andBlock:(normalBlock)block
{
    CHNormalButton *button = [[CHNormalButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.backgroundColor = backcolor;
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.titleLabel.textAlignment = aligment;
    [button addTarget:button action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.block = block;
    
    return button;
}

- (void)clickButton:(CHNormalButton *)button
{
    button.block(button);
}

@end
