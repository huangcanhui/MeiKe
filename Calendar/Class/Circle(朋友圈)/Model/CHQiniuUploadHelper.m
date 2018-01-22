//
//  CHQiniuUploadHelper.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/22.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHQiniuUploadHelper.h"

@implementation CHQiniuUploadHelper

static id instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype)shareUploadHelper
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

@end
