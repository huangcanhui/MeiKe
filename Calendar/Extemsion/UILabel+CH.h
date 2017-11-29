//
//  UILabel+CH.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CH)
/**
 这是一个自适应高度的方法
 @param width 给定一个具体的宽度
 @param title 内容
 @param font 字体大小
 @return 返回高度
 */
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

/**
 自适应宽度
 @param title 内容
 @param font 字体大小
 @return 宽度
 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
@end
