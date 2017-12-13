//
//  CHTimeSliderView.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/13.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTimeSliderView;

@protocol CHTimeSliderViewDelegate <NSObject>
@optional
- (void)sliderValueChanging:(CHTimeSliderView *)slider;
@end

@interface CHTimeSliderView : UIView
/**
 * 背景文字
 */
@property (nonatomic, copy)NSString *text;
/**
 * 最小值,最大值
 */
@property (nonatomic, assign)CGFloat minValue;
@property (nonatomic, assign)CGFloat maxValue;
/**
 * 代理
 */
@property (nonatomic, weak)id <CHTimeSliderViewDelegate>delegate;

/**
 * 设置滑动条的颜色
 * @param backColor 背景颜色
 * @param sliderColor 滑动过后的颜色
 * @param textColor 文字的颜色
 * @param borderColor 边框的颜色
 */
- (void)setColorForBackView:(UIColor *)backColor sliderColor:(UIColor *)sliderColor textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor;

/**
 *  设置滑动条进度
 */
- (void)setSliderValue:(CGFloat)value;
@end
