//
//  CHPublishView.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPublishView : UIView
/**
 * 获取到输入的文字和照片数组
 */
@property (nonatomic, copy)void (^getData)(NSString *title, NSArray *array);
@end
