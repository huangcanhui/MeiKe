//
//  CHScanCodeViewController.h
//  YMStars
//
//  Created by HFY on 2017/8/3.
//  Copyright © 2017年 huangcanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    addFriend, //添加好友
    addTeam, //加入组队
    checkEnter //验证是否报名
}ScancodeType;

@interface CHScanCodeViewController : UIViewController

//这是一个枚举的类型，具体内容请查看上面
@property (nonatomic, assign)ScancodeType type;

@end
