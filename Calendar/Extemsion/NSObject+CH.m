//
//  NSObject+CH.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "NSObject+CH.h"
#import "MJExtension.h"

@implementation NSObject (CH)

- (void)reload
{
    
}

- (void)writeUserDefaultWithKey:(NSString *)key
{
    id obj;
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSValue class]]) {
        obj = self ;
    } else {
        obj = [self mj_JSONObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
}

+ (id)readUserDefaultWithKey:(NSString *)key
{
    id jsonObj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!jsonObj) return nil;
    id obj = nil;
    if ([jsonObj isKindOfClass:[NSString class]] || [jsonObj isKindOfClass:[NSValue class]]) {
        obj = jsonObj;
    } else if ([jsonObj isKindOfClass:[NSArray class]]) {
        obj = [self mj_objectArrayWithKeyValuesArray:jsonObj];
    } else if ([jsonObj isKindOfClass:[NSDictionary class]]){
        NSDictionary *o = (NSDictionary *)jsonObj;
        if (o.count == 0) return nil;
        obj = [self mj_objectWithKeyValues:jsonObj];
        if ([obj isKindOfClass:self]) {
            return obj;
        }
        return nil;
    }
    return obj;
}

- (void)removeUserDefaultWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
@end
