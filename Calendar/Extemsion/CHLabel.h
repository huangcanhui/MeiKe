//
//  CHLabel.h
//  ShareTheBike
//
//  Created by 黄灿辉 on 2017/3/30.
//  Copyright © 2017年 黄灿辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHLabel : UILabel
/*------ 普通的UIlabel的创建 --------*/
+ (CHLabel *)labelFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment)alignment andTextFont:(CGFloat)font;

/*----- 需要使用富文本的label ------*/
+ (CHLabel *)labelFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment)alignment andTextFont:(CGFloat)font andSubtitle:(NSString *)subTitle andSubColor:(UIColor *)subColor andSubFont:(CGFloat)subFont;

/*------ 创建一个图文富文本 ------*/
+ (CHLabel *)labelFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment)alignment andTextFont:(CGFloat)font imageName:(NSString *)imageName imageFrame:(CGRect)imageFrame andImagePosition:(BOOL)isPosition;
@end
