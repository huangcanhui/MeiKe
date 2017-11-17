//
//  CHPersonalDataDetailViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/17.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 这是一个用户进入的枚举类型
 */
typedef enum {
    typeWithPicture = 0, //图片
    typeWithText , //以需要输入文字的方式进入
    typeWithScanCode, //二维码
}PersonalDataType;
@interface CHPersonalDataDetailViewController : UIViewController

@property (nonatomic, copy)void (^whenClickSubmitButton)(NSString *string);

/**
 * 这是一个枚举类型，值请查看上面的定义
 */
@property (nonatomic, assign)PersonalDataType type;

/**
 * 获取用户的ID
 * 获取用户的二维码才需要传值
 */
@property (nonatomic, strong)NSNumber *num;

/**
 * 标题
 */
@property (nonatomic, copy)NSString *text;

@end
