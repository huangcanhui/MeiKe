//
//  CHQiniuUploadTool.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/22.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import <UIKit/UIKit.h>

@interface CHQiniuUploadTool : NSObject
/**
 * 获取七牛上传的token
 */
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)(void))failure;
/**
 * 上传图片
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)(void))failure;

/**
 *  上传多张图片,按队列依次上传
 */
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)(void))failure;
@end
