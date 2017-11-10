//
//  mobile.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mobile : NSObject

@end

@class User ;

@interface User :NSObject
@property (nonatomic, copy)NSString *access_token; //用户token
@property (nonatomic, copy)NSString *token_type;
@property (nonatomic, copy)NSString *expires_in; //过期时间
@property (nonatomic, copy)NSString *refresh_token; //刷新token
@end
