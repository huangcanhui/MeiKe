//
//  CHWebViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/28.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHWebViewController : UIViewController
/**
 * 传递需要展示的网页接口
 */
@property (nonatomic, copy)NSString *webString;
/**
 * 页面标题
 */
@property (nonatomic, copy)NSString *content;
@end
