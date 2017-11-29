//
//  MAP.h
//  YMStars
//
//  Created by HFY on 2017/8/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAP : NSObject
@property (nonatomic, copy)NSString *title;//店名
@property (nonatomic, copy)NSString *address;//地址
@property (nonatomic, copy)NSString *lat;//经纬度
@property (nonatomic, copy)NSString *lng;

@end
