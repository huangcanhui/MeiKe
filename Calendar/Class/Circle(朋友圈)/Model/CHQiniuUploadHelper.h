//
//  CHQiniuUploadHelper.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/22.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHQiniuUploadHelper : NSObject
/**
 * 成功的回调
 */
@property (nonatomic, copy)void (^singleSuccessBlock)(NSString *);
/**
 * 失败的回调
 */
@property (nonatomic, copy)void (^singleFailureBlock)();
/**
 * 单例
 */
+ (instancetype)shareUploadHelper;

@end
