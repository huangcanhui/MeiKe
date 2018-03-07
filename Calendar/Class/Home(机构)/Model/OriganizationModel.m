//
//  OriganizationModel.m
//  Calendar
//
//  Created by huangcanhui on 2018/3/7.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "OriganizationModel.h"
#import "MJExtension.h"

@implementation OriganizationModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (dic) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"detail":[DetailObject class]
             };
}

@end


@implementation DetailObject

@end
