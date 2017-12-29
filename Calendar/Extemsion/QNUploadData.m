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

@implementation QNUploadData

+ (BOOL)uploadDataFile:(NSArray *)array
{
    //获取七牛上传的token
    NSString *url = CHReadConfig(@"qn_uploadToken_Url");
    [[CHManager manager] requestWithMethod:GET WithPath:url WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        NSString *token = responseObject[@"uptoken"];
        for (int i = 0; i < array.count; i++) {
            //给图片创建一个唯一的名称
            NSString *string = [NSString stringWithFormat:@"图片上传中！\n第%d/%lu张", i + 1, (unsigned long)array.count];
            [ProgressHUD show:string Interaction:NO];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@", str];
            NSData *data = UIImagePNGRepresentation(array[i][@"image"]);
            //配置上传实例
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                NSMutableArray *arrayM = [NSMutableArray array];
                [arrayM addObject:[QNResolver systemResolver]];
                QNDnsManager *dns = [[QNDnsManager alloc] init:[arrayM copy] networkInfo:[QNNetworkInfo normal]];
                builder.zone = [[QNAutoZone alloc] initWithDns:dns];
            }];
            QNUploadManager *upmanager = [[QNUploadManager alloc] initWithConfiguration:config];
//            QNUploadManager *upmanager = [[QNUploadManager alloc] init];
            [upmanager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"%@", resp[@"key"]);
                if (i == array.count - 1 && resp[@"key"] != nil) {
                    [ProgressHUD showSuccess:@"图片上传成功"];
                }
            } option:nil];
        }
    } WithFailurBlock:^(NSError *error) {
        
    }];
    
    return YES;
}

@end
