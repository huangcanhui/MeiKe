//
//  CHImageButton.m
//  ShareTheBike
//
//  Created by 黄灿辉 on 2017/3/31.
//  Copyright © 2017年 黄灿辉. All rights reserved.
//

#import "CHImageButton.h"

@implementation CHImageButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    switch (_mode) {
        case addButtonTop:
        {
            CGFloat X = contentRect.size.width * _spacing;
            CGFloat Y = 0;
            CGFloat imageW = contentRect.size.width * _Scale;
            CGFloat imageH = contentRect.size.height * _Scale;
            return CGRectMake(X, Y, imageW, imageH);
        }
            break;
        case addButtonLeft:
        {
            CGFloat imageW = contentRect.size.width * _Scale;
            CGFloat imageH = contentRect.size.width * _Scale;
            CGFloat X = contentRect.size.width * _spacing;
            CGFloat Y = contentRect.size.height * _spacing;
            return CGRectMake(X, Y, imageW, imageH);
        }
            break;
        case addButtonright:
        {
            CGFloat X = contentRect.size.width * _Scale;
            CGFloat Y = 0;
            CGFloat imageW = contentRect.size.width * (1 - _Scale);
            CGFloat imageH = contentRect.size.height;
            
            return CGRectMake(X, Y, imageW, imageH);
        }
            break;
        case addButtonBottom:
        {
            CGFloat X = 0;
            CGFloat Y = contentRect.size.height * _Scale;
            CGFloat imageW = contentRect.size.width;
            CGFloat imageH = contentRect.size.height * (1 - _Scale);
            
            return CGRectMake(X, Y, imageW, imageH);
        }
            break;
        default:
            break;
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    switch (_mode) {
        case addButtonTop:
        {
            CGFloat X = 0;
            CGFloat Y = contentRect.size.height * (_Scale + 0.05);
            CGFloat titleW = contentRect.size.width * _Scale;
            CGFloat titleH = contentRect.size.height * (1 - _Scale);
            return CGRectMake(X, Y, titleW, titleH);
        }
            break;
        case addButtonLeft:
        {
            CGFloat X = contentRect.size.width * (_Scale + 2 * _spacing);
            CGFloat Y = 0;
            CGFloat titleW = contentRect.size.width * (1 - _Scale - 2 * _spacing);
            CGFloat titleH = contentRect.size.height;
            return CGRectMake(X, Y, titleW, titleH);
        }
            break;
        case addButtonBottom:
        {
            CGFloat X = 0;
            CGFloat Y = 0;
            CGFloat titleW = contentRect.size.width;
            CGFloat titleH = contentRect.size.height * _Scale;
            return CGRectMake(X, Y, titleW, titleH);
        }
            break;
        case addButtonright:
        {
            CGFloat X = 0;
            CGFloat Y = 0;
            CGFloat titleW = contentRect.size.width * (1 - _Scale);
            CGFloat titleH = contentRect.size.height;
            return CGRectMake(X, Y, titleW, titleH);
        }
            break;
            
        default:
            break;
    }
}

@end
