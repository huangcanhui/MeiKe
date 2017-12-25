//
//  CHPublishView.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 这是一个视图的枚举方法
 */
typedef enum {
    viewWithTextAndPhoto = 0, //图文相间
    viewWithOnlytext, //只有文字
}viewsStyle;
@interface CHPublishView : UIView
/**
 * 获取到输入的文字
 */
@property (nonatomic, copy)void (^getData)(NSString *title);
/**
 * 获取上传的图片数组
 */
@property (nonatomic, copy)void (^getPhotos)(NSArray *array);
///**
// * 这是一个视图的枚举
// */
//@property (nonatomic, assign)viewsStyle style;

- (CHPublishView *)initWithFrame:(CGRect)frame andStyle:(viewsStyle)style;
@end
