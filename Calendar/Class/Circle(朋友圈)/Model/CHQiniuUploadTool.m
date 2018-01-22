//
//  CHQiniuUploadTool.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/22.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHQiniuUploadTool.h"
#import "CHManager.h"
#import "CHQiniuUploadHelper.h"
#import "ImageCutDownManager.h"
#import "ProgressHUD.h"

@implementation CHQiniuUploadTool

/**
 * 给图片命名
 */
+ (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

/**
 * 随机生成一个指定长度的字符串
 */
+ (NSString *)randomStringWithLength:(int)len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

/**
 * 上传单张照片
 */
+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *))success failure:(void (^)(void))failure
{
    [CHQiniuUploadTool getQiniuUploadToken:^(NSString *token) {
        //对图片进行压缩处理，防止上传的图片过大，造成上传缓慢
        NSData *data = [ImageCutDownManager zipNSDataWithImage:image];
        //如果不存在则直接返回
        if (!data) {
            if (failure) {
                failure();
            }
            return ;
        }
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [CHQiniuUploadTool getDateTimeString], [CHQiniuUploadTool randomStringWithLength:3]];
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        [uploadManager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                if (success) {
                    success(resp[@"key"]);
                }
            } else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        
    }];
}

/**
 * 上传多张图片
 */
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)(void))failure
{
    NSMutableArray *array = [[NSMutableArray array] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat parPregress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    CHQiniuUploadHelper *uploadHelper = [CHQiniuUploadHelper shareUploadHelper];
    
    __weak typeof (uploadHelper) weakHelper = uploadHelper;
    uploadHelper.singleFailureBlock = ^{
        failure();
        return ;
    };
    
    uploadHelper.singleSuccessBlock = ^(NSString *url) {
        [array addObject:url];
        totalProgress += parPregress;
        progress(totalProgress);
        currentIndex ++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return ;
        } else {
            if (currentIndex < imageArray.count) {
                [CHQiniuUploadTool uploadImage:imageArray[currentIndex][@"image"] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
        }
    };
    [CHQiniuUploadTool uploadImage:imageArray[0][@"image"] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
    
}

/**
 * 获取七牛上传token
 */
+ (void)getQiniuUploadToken:(void (^)(NSString *))success failure:(void (^)(void))failure
{
    NSString *url = CHReadConfig(@"qn_uploadToken_Url");
    [[CHManager manager] requestWithMethod:GET WithPath:url WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        if (success) {
            success(responseObject[@"uptoken"]);
        }
    } WithFailurBlock:^(NSError *error) {
        [ProgressHUD showError:@"七牛token获取失败"];
    }];
}

@end
