//
//  CHPublishViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 这是一个点击方式的枚举
 */
typedef enum {
     clickLongPress = 0,
    clickGes,
}GesStyle;

@interface CHPublishViewController : UIViewController
/**
 * 传递用户的点击方式
 */
@property (nonatomic, assign)GesStyle style;
@end
