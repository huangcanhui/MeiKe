//
//  CHPersonalGroup.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHPersonalGroup.h"
#import "MJExtension.h"

@implementation CHPersonalGroup

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
             @"activity":[CHPersonalModel class]
             };
}

@end
