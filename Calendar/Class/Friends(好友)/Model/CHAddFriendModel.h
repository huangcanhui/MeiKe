//
//  CHAddFriendModel.h
//  Calendar
//
//  Created by huangcanhui on 2018/1/4.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirendListObject.h"
#import "MJExtension.h"

@interface CHAddFriendModel : NSObject
/**
 * id
 */
@property (nonatomic, strong)NSNumber *id;
/**
 * 状态码
 */
@property (nonatomic, strong)NSNumber *status;
/**
 * 备注
 */
@property (nonatomic, copy)NSString *message;
/**
 * 创建时间
 */
@property (nonatomic, copy)NSString *created_at;
/**
 * 请求者的ID
 */
@property (nonatomic, strong)NSNumber *sender_id;
/**
 * 请求者的信息
 */
@property (nonatomic, strong)FirendListObject *sender;

@end
