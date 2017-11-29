//
//  CHSettingModel.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHSettingModel.h"
#import "AFNetworkReachabilityManager.h"

static CHSettingModel *obj = nil;
@implementation CHSettingModel
+ (instancetype)defaultInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        obj = [[self alloc] init];
        [obj initData];
    });
    return obj;
}

- (void)initData
{
    [obj loadCache];
}

- (void)loadCache
{
    NSNumber *imageMode = [NSNumber readUserDefaultWithKey:@"imageMode"];
    _imageMode = imageMode.intValue;
}

- (void)saveCache
{
    NSNumber *imageMode = @(self.imageMode);
    [imageMode writeUserDefaultWithKey:@"imageMode"];
}

- (void)clearCache
{
    [self removeUserDefaultWithKey:@"imageMode"];
}

- (void)setImageMode:(ImageMode)imageMode
{
    if (imageMode == _imageMode) { //
        return;
    }
    _imageMode = imageMode;
    if (imageMode == ImageModeAuto) {
        //设置成智能模式的时候，需要自行判断一次此时的网络状况
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
            self.currentMode = ImageModeHighQuality;
        } else {
            self.currentMode = ImageModeNormal;
        }
    }
    [self saveCache];
}

- (void)dealloc
{
    [self saveCache];
}
@end
