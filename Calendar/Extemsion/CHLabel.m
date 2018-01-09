//
//  CHLabel.m
//  ShareTheBike
//
//  Created by 黄灿辉 on 2017/3/30.
//  Copyright © 2017年 黄灿辉. All rights reserved.
//

#import "CHLabel.h"

@implementation CHLabel

+ (CHLabel *)labelFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment)alignment andTextFont:(CGFloat)font
{
    CHLabel *label = [[CHLabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = titleColor;
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

+ (CHLabel *)labelFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment)alignment andTextFont:(CGFloat)font andSubtitle:(NSString *)subTitle andSubColor:(UIColor *)subColor andSubFont:(CGFloat)subFont
{
    CHLabel *label = [[CHLabel alloc] initWithFrame:frame];
    label.textColor = titleColor;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = alignment;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:subTitle];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:subFont], NSForegroundColorAttributeName:subColor} range:range];
    [label setText:title];
    [label setAttributedText:attribute];
    return label;
}

+ (CHLabel *)labelFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment)alignment andTextFont:(CGFloat)font imageName:(NSString *)imageName imageFrame:(CGRect)imageFrame andImagePosition:(BOOL)isPosition
{
    CHLabel *label = [[CHLabel alloc] initWithFrame:frame];
    
    label.textColor = titleColor;
    
    label.textAlignment = alignment;
    
    label.font = [UIFont systemFontOfSize:font];
    
    //创建一个富文本
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    //图片名称
    attach.image = [UIImage imageNamed:imageName];
    //图片位置
    attach.bounds = imageFrame;
    
    NSString *subString = [NSString stringWithFormat:@"%@", title];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:subString];
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attach];
    
    if (isPosition) { //为No时为图片在前文字在后
        [attri insertAttributedString:string atIndex:0];
    } else { //为YES时，为图片在后文字在前
        [attri appendAttributedString:string];
    }
    label.attributedText = attri;
    
    return label;
}

@end
