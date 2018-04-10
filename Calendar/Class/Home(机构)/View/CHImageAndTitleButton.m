//
//  CHImageAndTitleButton.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/10.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHImageAndTitleButton.h"

@implementation CHImageAndTitleButton

#pragma mark - 设置button内部图片的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.height * 0.65;
    CGFloat imageH = contentRect.size.height * 0.65;
    CGFloat X = contentRect.size.width * 0.08;
    CGFloat Y = contentRect.size.height * 0.05;
    return CGRectMake(X, Y, imageW, imageH);
}

#pragma mark - 设置title的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat X = 0;
    CGFloat Y = contentRect.size.height * 0.7;
    CGFloat labelW = contentRect.size.width;
    CGFloat labelH = contentRect.size.height * 0.3;
    return CGRectMake(X, Y, labelW, labelH);
}

@end
