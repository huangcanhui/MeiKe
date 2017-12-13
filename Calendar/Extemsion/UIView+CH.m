//
//  UIView+CH.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "UIView+CH.h"
//#import <objc/runtime.h>

//static char tag_String;

@implementation UIView (CH)

//- (void)setTagString:(NSString *)tagString
//{
//    if (tagString == nil) {
//        objc_setAssociatedObject(self, &tag_String, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    } else {
//        objc_setAssociatedObject(self, &tag_String, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}
//
//- (NSString *)tagString
//{
//    return objc_getAssociatedObject(self, &tag_String);
//}
-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}

-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)x{
    
    return self.frame.origin.x;
}

-(CGFloat)y{
    
    return self.frame.origin.y;
}

- (CGFloat)CH_height
{
    return self.frame.size.height;
}

- (CGFloat)CH_width
{
    return self.frame.size.width;
}

- (CGFloat)CH_top
{
    return self.frame.origin.y;
}

- (CGFloat)CH_left
{
    return self.frame.origin.x;
}

- (CGFloat)CH_right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)CH_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setCH_height:(CGFloat)CH_height
{
    CGRect frame = self.frame;
    frame.size.height = CH_height;
    self.frame = frame;
}

- (void)setCH_width:(CGFloat)CH_width
{
    CGRect frame = self.frame;
    frame.size.width = CH_width;
    self.frame = frame;
}

- (void)setCH_top:(CGFloat)CH_top
{
    CGRect frame = self.frame;
    frame.origin.y = CH_top;
    self.frame = frame;
}

- (void)setCH_left:(CGFloat)CH_left
{
    CGRect frame = self.frame;
    frame.origin.x = CH_left;
    self.frame = frame;
}

- (void)setCH_right:(CGFloat)CH_right
{
    CGRect frame = self.frame;
    frame.origin.x = CH_right;
    self.frame = frame;
}

- (void)setCH_bottom:(CGFloat)CH_bottom
{
    CGRect frame = self.frame;
    frame.origin.x = CH_bottom;
    self.frame = frame;
}
@end
