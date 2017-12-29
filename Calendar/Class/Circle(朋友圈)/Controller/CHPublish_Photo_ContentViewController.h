//
//  CHPublish_Photo_ContentViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/28.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHViewController.h"
/**
 * 这是一个枚举类型，用来定义用户发布的是文字还是图文
 */
typedef enum {
    typeWithContent = 0, //文字形式
    typeWithPhotoAndContent //图文形式
}publishType;

@interface CHPublish_Photo_ContentViewController : CHViewController

@property (nonatomic, assign)publishType type;

@end
