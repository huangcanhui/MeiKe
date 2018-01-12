//
//  CHUserView.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mobile.h"

@interface CHUserView : UIView

@property (nonatomic, strong)User *user;

/**
 * 当登录按钮被点击时
 */
@property (nonatomic, copy)void (^whenLoginBtnClick)(void);

+ (instancetype)headerView;

@end
