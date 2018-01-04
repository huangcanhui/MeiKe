//
//  ImageCutDownManager.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/2.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

/****************************** 这是一个队图片进行裁剪压缩的方法 ***************************************************/
#import <Foundation/Foundation.h>

@interface ImageCutDownManager : NSObject
/**
 * 对图片进行缩处理
 */
+ (UIImage *)zipScaleWithImage:(UIImage *)sourceImage;
/**
 * 对图片进行压处理
 */
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

@end
