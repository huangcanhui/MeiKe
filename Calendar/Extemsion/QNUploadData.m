//
//  QNUploadData.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "QNUploadData.h"
#import "CHManager.h"
#import <QiniuSDK.h>
#import "ProgressHUD.h"
#import "HappyDNS.h"
#import "ImageCutDownManager.h"

@implementation QNUploadData

+ (void)uploadDataFile:(NSArray *)array
{
    //获取七牛上传的token
    NSMutableArray *arrayM = [NSMutableArray array];
    NSString *url = CHReadConfig(@"qn_uploadToken_Url");
    [[CHManager manager] requestWithMethod:GET WithPath:url WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        NSString *token = responseObject[@"uptoken"];
        NSLog(@"token:%@", token);
        [ProgressHUD show:@"上传中,请稍后..." Interaction:NO];
        for (int i = 0; i < array.count; i++) {
            //给图片创建一个唯一的名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            NSString *fileName = [NSString stringWithFormat:@"%@%d", str, i];
            NSData *data = [ImageCutDownManager zipNSDataWithImage:array[i][@"image"]];
            //配置上传实例
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                NSMutableArray *arrayM = [NSMutableArray array];
                [arrayM addObject:[QNResolver systemResolver]];
                QNDnsManager *dns = [[QNDnsManager alloc] init:[arrayM copy] networkInfo:[QNNetworkInfo normal]];
                builder.zone = [[QNAutoZone alloc] initWithDns:dns];
            }];
            QNUploadManager *upmanager = [[QNUploadManager alloc] initWithConfiguration:config];
            NSLog(@"%@", fileName);
            [upmanager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [arrayM addObject:resp[@"key"]];
                if (i == array.count - 1) {
                    [ProgressHUD dismiss];
                    NSDictionary *params = @{
                                             @"imageArray":arrayM
                                             };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessImageArrayUp" object:nil userInfo:params];
                }
            } option:nil];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

@end
