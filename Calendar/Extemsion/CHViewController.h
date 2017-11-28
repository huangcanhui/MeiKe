//
//  CHViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/28.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHViewController : UIViewController<UIAlertViewDelegate>
/**
 *  便利获得一个提示框
 *
 *  @param title            提示框名称
 *  @param message          提示信息
 *  @param cancelTitle      取消的标题
 *  @param otherTitles      其他的标题
 *  @param whenClickedFirst 点击其他的标题（第一个）的操作
 *  @param completion       完成后的操作
 */
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles block:(void(^)(void))whenClickedFirst completion:(void (^)(void))completion ;
/**
 *  便利获得一个提示框
 *
 *  @param title            提示框名称
 *  @param message          提示信息
 *  @param cancelTitle      取消的标题
 *  @param otherTitles      其他的标题
 *  @param whenClickedFirst 点击其他的标题（第一个）的操作
 */
- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles block:(void(^)(void))whenClickedFirst ;
@end
