//
//  QNUploadData.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNUploadData : NSObject
/**
 * 判断上传成功还是失败
 */
+ (void)uploadDataFile:(NSArray *)array;

@end
