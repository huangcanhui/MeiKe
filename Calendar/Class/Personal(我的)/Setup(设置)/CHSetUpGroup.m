//
//  CHSetUpGroup.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSetUpGroup.h"
#import "MJExtension.h"

@implementation CHSetUpGroup

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        if (dict) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"project":[CHSetUpModel class]
             };
}

@end
