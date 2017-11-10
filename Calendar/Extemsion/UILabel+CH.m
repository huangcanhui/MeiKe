//
//  UILabel+CH.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "UILabel+CH.h"

@implementation UILabel (CH)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label.frame.size.height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
