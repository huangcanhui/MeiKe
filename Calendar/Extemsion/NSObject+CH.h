//
//  NSObject+CH.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CH)

- (void)reload;
/*
 *将一个对象写入userDefault
 **/
- (void)writeUserDefaultWithKey:(NSString *)key;
/*
 * 将一个对象从UserDefault中读出
 **/
+ (id)readUserDefaultWithKey:(NSString *)key;
/*
 * 将一个对象从UserDefault中删除
 **/
- (void)removeUserDefaultWithKey:(NSString *)key;

@end
