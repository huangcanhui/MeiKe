//
//  UIView+CH.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CH)
/**
 给View绑定一个标签属性
 */
@property (nonatomic, copy)NSString *tagString;

/*------ view的四个方位快速获取的方法 -----*/
@property (nonatomic, assign)CGFloat CH_height;
@property (nonatomic, assign)CGFloat CH_width;
@property (nonatomic, assign)CGFloat CH_left;
@property (nonatomic, assign)CGFloat CH_right;
@property (nonatomic, assign)CGFloat CH_top;
@property (nonatomic, assign)CGFloat CH_bottom;

///**
// 通过tagstring找到当前对象的子view中包含此tagstring的view
// */
//- (UIView *)viewWithTagString:(NSString *)tagString;
@end
