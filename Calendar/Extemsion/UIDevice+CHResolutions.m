//
//  UIDevice+CHResolutions.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "UIDevice+CHResolutions.h"

@implementation UIDevice (CHResolutions)

//获取手机屏幕的分辨率
+ (DeviceScale)currentDeviceScale
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    //获取屏幕的分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *current = [NSString stringWithFormat:@"%.f * %.f", width * scale_screen, height * scale_screen];
    NSLog(@"%@", current);
    if ([current isEqualToString:@"1125 * 2346"]) { //iphone X
        return iphoneX;
    } else {
        return other;
    }
}

@end
