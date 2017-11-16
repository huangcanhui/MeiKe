//
//  CHPersonalModel.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHPersonalModel.h"

@implementation CHPersonalModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (dic) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    return self;
}

@end
