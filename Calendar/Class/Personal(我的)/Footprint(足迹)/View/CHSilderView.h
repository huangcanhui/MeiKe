//
//  CHSilderView.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/13.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHSilderView;

@protocol CHSliderViewDelgate <NSObject>
@optional
- (void)sliderValueChanging:(CHSilderView *)slider;
- (void)sliderEndValueChanged:(CHSilderView *)slider;
@end

@interface CHSilderView : UIView
/**
 * 数值
 */
@property (nonatomic, assign) CGFloat value;
/**
 * 文字
 */
@property (nonatomic, copy) NSString *text;
/**
 * 字体大小
 */
@property (nonatomic, strong)UIFont *font;
/**
 * 图片
 */
@property (nonatomic,strong) UIImage *thumbImage;
@property (nonatomic,strong) UIImage *finishImage;
/**
 * 图片是否保持
 */
@property (nonatomic, assign) BOOL thumbHidden;
/**
 * 拖动后是否返回
 */
@property (nonatomic,assign) BOOL thumbBack;
/**
 * 是否竖直放置
 */
@property (nonatomic, assign) BOOL isVertical;
/**
 * 代理
 */
@property (nonatomic, weak) id<CHSliderViewDelgate> delegate;
/**
 *  设置滑动条进度
 *  value取值0~1
 */
- (void)setSliderValue:(CGFloat)value;
/**
 *  动画设置滑动条进度
 */
- (void)setSliderValue:(CGFloat)value animation:(BOOL)animation completion:(void(^)(BOOL finish))completion;
/**
 *  设置滑动条颜色
 *
 *  @param backgroud  背景色
 *  @param foreground 前景色
 *  @param thumb      滑动控件颜色
 *  @param border     边框色
 */
- (void)setColorForBackgroud:(UIColor *)backgroud foreground:(UIColor *)foreground thumb:(UIColor *)thumb border:(UIColor *)border textColor:(UIColor *)textColor;
/**
 *  设置滑动控件的起始图片和完成图片(可选)
 *
 *  @param beginImage 启始图片
 *  @param finishImage   完成图片
 */
- (void)setThumbBeginImage:(UIImage *)beginImage finishImage:(UIImage *)finishImage;
/**
 *  移除圆角和边框
 */
- (void)removeRoundCorners:(BOOL)corners border:(BOOL)border;

@end
