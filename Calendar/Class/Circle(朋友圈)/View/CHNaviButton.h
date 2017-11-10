//
//  CHNaviButton.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHNaviButton;

typedef void(^naviBlock)(CHNaviButton *button);

@interface CHNaviButton : UIButton

@property (nonatomic, copy)naviBlock tempBlock;

//客服按钮、扫一扫按钮
/**
 * 这是一个包含图片的按钮
 */
+ (CHNaviButton *)buttonwWithFrame:(CGRect)frame type:(UIButtonType)type andFont:(int)font andTitle:(NSString *)title  andTitleColor:(UIColor *)color imageName:(NSString *)imageName andBoolLabel:(BOOL)boolLabel andTmepBlock:(naviBlock)block;

@end
