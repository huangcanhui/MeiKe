//
//  CHBarButtonItem.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHBarButtonItem : UIBarButtonItem

@property (nonatomic, strong)UIButton *button;

/**
 * 初始化包含图片的
 */
- (CHBarButtonItem *)initWithLeftBarButton:(NSString *)title target:(id)target action:(SEL)method;

/**
 * 初始化包含图片的UIBarButtonItem
 */
- (CHBarButtonItem *)initContainImage:(UIImage *)buttonImage imageViewFrame:(CGRect)imageFrame buttonTitle:(NSString *)buttonTitle titleColor:(UIColor *)titleColor titleFrame:(CGRect)titleFrame buttonFrame:(CGRect)buttonFrame target:(id)target action:(SEL)method;

/**
 * 初始化不包含图片的UIBarButtonItem
 */
- (CHBarButtonItem *)initWithButtonTitle:(NSString *)buttonTitle titleColor:(UIColor *)titleColor buttonFrame:(CGRect)buttonFrame target:(id)target action:(SEL)method;

/**
 * 设置UIBarButtonItem是否可以被点击和对应的颜色
 */
- (void)buttonIsCanClick:(BOOL)isCanClick buttonColor:(UIColor *)buttonColor barButtonItem:(CHBarButtonItem *)barButtonItem;

/**
 * 平移UIBarButtonItem
 */
- (NSArray <UIBarButtonItem *> *)setTranslation:(UIBarButtonItem *)barButtonItem translation:(CGFloat)translation;



@end
