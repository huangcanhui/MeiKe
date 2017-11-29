//
//  CHShareManager.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/28.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHShareManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

#import "SVProgressHUD.h"

@implementation CHShareManager

DEF_SINGLETON(CHShareManager)

+ (void)shareToFriendsViewController:(UIViewController *)vc withTitle:(NSString *)title content:(NSString *)content withUrl:(NSString *)url
{
    //设置面板中的分享平台顺序
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone), @(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine)]];
    
    //弹出面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [[CHShareManager sharedInstance] shareContentToPlatFormType:platformType viewController:vc withTitle:title content:content url:url];
    }];
}

- (void)shareContentToPlatFormType:(UMSocialPlatformType)platformType viewController:(UIViewController *)viewController withTitle:(NSString *)title content:(NSString *)content url:(NSString *)url
{
    //创建分享的消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //根据获取的plateform选择一下的操作
    switch (platformType) {
        case UMSocialPlatformType_QQ:
        case UMSocialPlatformType_Qzone:
        case UMSocialPlatformType_WechatSession:
        case UMSocialPlatformType_WechatTimeLine:
        {
            //创建网页内容对象
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageNamed:@"LOGO"]];
            //设置网页地址
            shareObject.webpageUrl = url;
            //分享的内容对象
            messageObject.shareObject = shareObject;
        }
            break;
            
        default:
        {
//            [ProgressHUD showError:@"很抱歉，出错了!"];
            [SVProgressHUD showErrorWithStatus:@"很抱歉，出错了！"];
        }
            break;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id result, NSError *error) {
        if (!error) { //发送成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [ProgressHUD showSuccess:@"分享成功"];
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            });
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [ProgressHUD showError:@"分享失败"];
                [SVProgressHUD showErrorWithStatus:@"分享失败"];
            });
        }
    }];
}

+ (NSString *)shareAPPDownloadUrl
{
    //APP的下载地址
    return @"";
}

@end
