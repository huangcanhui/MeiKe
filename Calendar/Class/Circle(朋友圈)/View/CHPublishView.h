//
//  CHPublishView.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPublishView : UIView
/**
 * 获取到输入的文字
 */
@property (nonatomic, copy)void (^getData)(NSString *title);
@end
