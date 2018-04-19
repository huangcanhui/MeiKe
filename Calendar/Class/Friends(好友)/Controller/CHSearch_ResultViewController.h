//
//  CHSearch_ResultViewController.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/19.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirendListObject.h"

@interface CHSearch_ResultViewController : UIViewController

/**
 * 页面标题
 */
@property (nonatomic, copy)NSString *vctitle;
/**
 * 用户的数据源
 */
@property (nonatomic, strong)FirendListObject *object;

@end
