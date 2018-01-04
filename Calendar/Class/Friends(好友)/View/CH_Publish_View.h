//
//  CH_Publish_View.h
//  YMStars
//
//  Created by HFY on 2017/8/11.
//  Copyright © 2017年 huangcanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CH_Publish_View : UIView

@property (nonatomic, copy)void (^whenButtonClick)(NSInteger tag);

+ (CH_Publish_View *)setPublishViewFrame:(CGRect)frame andBackground:(UIColor *)color andTitleArray:(NSArray *)titleArray  andImageArray:(NSArray *)imageArray andTitleColor:(UIColor *)titleColor andTitleFont:(int)font andTitleBackground:(UIColor *)titleBackground;

/**
 * 这个弹框的视图
 */
+ (CH_Publish_View *)setViewFrame:(CGRect)frame andBackground:(UIColor *)color andSubBackground:(UIColor *)background;

@end
