//
//  CHManager.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD,
    PATCH,
} HTTPMethod;

@interface CHManager : AFHTTPSessionManager

+ (instancetype)manager;
/*
 * 网络请求方式
 * method 为请求方式get、post等
 * path 后台获取的网络接口
 * params传递给后台的参数
 * success 请求回调成功的block
 * failure 请求失败回调的block
 **/
- (void)requestWithMethod:(HTTPMethod)method WithPath:(NSString *)path WithParams:(NSDictionary*)params WithSuccessBlock:(requestSuccessBlock)success WithFailurBlock:(requestFailureBlock)failure;

//@property (nonatomic, strong)UPLOADFORM *uploadForm; //图片上传需要提供的参数
//图片上传
- (void)uploadWithURLString:(NSString *)urlString withParams:(NSDictionary *)params withImageData:(NSData *)data withSuccessBlock:(requestSuccessBlock)success withFailurBlock:(requestFailureBlock)failure;

@end
