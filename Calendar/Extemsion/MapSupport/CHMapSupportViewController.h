//
//  CHMapSupportViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/10.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@interface CHMapSupportViewController : UIViewController
/**
 * 获取地址的回调
 */
@property (nonatomic, copy)void (^whenAddressGet)(Address *address);

@end
