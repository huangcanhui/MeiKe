//
//  CHImageButton.h
//  ShareTheBike
//
//  Created by 黄灿辉 on 2017/3/31.
//  Copyright © 2017年 黄灿辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { //以图片为基准
    addButtonTop = 0, //图片在上文字在下
    addButtonBottom, //图片在下文字在上
    addButtonLeft, //图片在左，文字在右
    addButtonright //图片在右，文字在左
} addButtonDirectionMode;

@interface CHImageButton : UIButton
/*
 * 这两个方法主要用来计算按钮中图片和文字的比例和位置
 * 比例只给一个可能不够，如果后期需要的话，可以增加到四个
 **/
@property (nonatomic, assign)CGFloat Scale; //这是按钮中imageView和label的比例
@property (nonatomic, assign)CGFloat spacing; //这是按钮间隔比例
@property (nonatomic, assign)addButtonDirectionMode mode; //当前需要的文字和图片的模式
@end
