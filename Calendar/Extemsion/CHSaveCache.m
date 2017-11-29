//
//  CHSaveCache.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSaveCache.h"
#import "SDImageCache.h"

@implementation CHSaveCache
+ (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths lastObject];
    return cacheDir;
}

+ (CGFloat)floderSizeAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        //目录下的文件计算大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        //SDWebImage的缓存计算
        size += [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
        //将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}

+ (void)cleanCaches:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *childrenFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            //拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            //将文件删除
            [manager removeItemAtPath:absolutePath error:nil];
        }
    }
    //SDWebImage的清除功能
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}
@end
