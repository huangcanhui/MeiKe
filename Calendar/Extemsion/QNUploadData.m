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

+ (NSArray *)uploadDataFile:(NSArray *)array
{
    //获取七牛上传的token
    NSMutableArray *arrayM = [NSMutableArray array];
    NSString *url = CHReadConfig(@"qn_uploadToken_Url");
    [[CHManager manager] requestWithMethod:GET WithPath:url WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        NSString *token = responseObject[@"uptoken"];
        for (int i = 0; i < array.count; i++) {
            //给图片创建一个唯一的名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@", str];
            NSData *data = [ImageCutDownManager zipNSDataWithImage:array[i][@"image"]];
            //配置上传实例
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                NSMutableArray *arrayM = [NSMutableArray array];
                [arrayM addObject:[QNResolver systemResolver]];
                QNDnsManager *dns = [[QNDnsManager alloc] init:[arrayM copy] networkInfo:[QNNetworkInfo normal]];
                builder.zone = [[QNAutoZone alloc] initWithDns:dns];
            }];
            QNUploadManager *upmanager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upmanager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [ProgressHUD show:@"上传中,请稍后..." Interaction:NO];
                [arrayM addObject:resp[@"key"]];
            } option:nil];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
    
    return [arrayM copy];
}

@end
