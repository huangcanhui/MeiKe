//
//  CHNormalButton.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHNormalButton;

typedef void(^normalBlock)(CHNormalButton *button);

@interface CHNormalButton : UIButton

@property (nonatomic, copy)normalBlock block;
/**
 * 这是一个按钮的封装
 * @parmas title 按钮文字
 * @parmas color 文字的颜色
 * @parmas font 字体的大小
 * @parmas aligment 文字对齐方式
 * @parmas backcolor 按钮的背景颜色
 * @parmas block 点击事件
 */
+ (CHNormalButton *)title:(NSString *)title titleColor:(UIColor *)color font:(CGFloat)font aligment:(NSTextAlignment)aligment backgroundcolor:(UIColor *)backcolor andBlock:(normalBlock)block;

@end
