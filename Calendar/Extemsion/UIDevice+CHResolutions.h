//
//  UIDevice+CHResolutions.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 这是一个关于手机型号的枚举
 */
typedef enum {
//    iPhone4 = 0,
//    iPhone5,
//    iPhone5s,
//    iPhone6,
//    iPhone6s,
//    iPhone6p,
//    iPhone6sp,
//    iPhone7,
//    iPhone7p,
//    iPhone8,
//    iPhone8p,
    other = 0,
    iphoneX
}DeviceScale;

@interface UIDevice (CHResolutions)

//通过手机的分辨率来获取手机的型号
+ (DeviceScale)currentDeviceScale;


@end
