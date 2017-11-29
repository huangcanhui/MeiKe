//
//  CHSettingModel.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 图片模式
 */
typedef NS_ENUM(NSInteger, ImageMode) {
    ImageModeAuto = 0, //智能模式
    ImageModeNormal , //普通质量模式
    ImageModeHighQuality //高质量模式
};
@interface CHSettingModel : NSObject
/**
 * 设置用户选择的图片模式
 */
@property (nonatomic, assign)ImageMode imageMode;
/**
 * 当imageMode为智能模式时，此字段用来存储计算得到的应采用的模式
 */
@property (nonatomic, assign)ImageMode currentMode;

+ (instancetype)defaultInstance;

/**
 * 清除缓存
 */
- (void)clearCache;

@end
