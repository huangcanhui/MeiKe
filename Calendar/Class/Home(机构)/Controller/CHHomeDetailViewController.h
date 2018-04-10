//
//  CHHomeDetailViewController.h
//  Calendar
//
//  Created by huangcanhui on 2018/3/7.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHomeDetailViewController : UIViewController
/**
 * 是否需要在左上角出现置顶按钮
 */
@property (nonatomic, assign)BOOL isStick;
/**
 * 传递机构的ID
 */
@property (nonatomic, strong)NSNumber *origanizationID;
/**
 * 机构名称
 */
@property (nonatomic, copy)NSString *simple_name;
/**
 * 回调刷新页面
 */
@property (nonatomic, copy)void (^getNewOriganization)(void);
@end
