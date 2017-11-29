//
//  CHShareManager.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/28.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonObject.h"

@interface CHShareManager : NSObject

AS_SINGLETON(CHShareManager)
/**
 * 这是分享功能的封装
 * @param vc 从什么页面跳转进入的
 * @param title 分享的标题
 * @param content 分享的内容
 * @param url 分享的网址
 */
+ (void)shareToFriendsViewController:(UIViewController *)vc withTitle:(NSString *)title content:(NSString *)content withUrl:(NSString *)url;

/**
 * 这是分享下载的地址，暂时还没有上线，预留
 */
+ (NSString *)shareAPPDownloadUrl;
@end
