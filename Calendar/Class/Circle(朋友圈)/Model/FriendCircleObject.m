//
//  FriendCircleObject.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/11.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "FriendCircleObject.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation FriendCircleObject

@synthesize content = _content;

- (void)setContent:(NSString *)content
{
    _content = content;
}

- (NSString *)content
{
    CGFloat contentW = kScreenWidth - 70;
    CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
    if (textRect.size.height > maxContentLabelHeight) {
        _shouldShowMoreButton = YES;
    } else {
        _shouldShowMoreButton = NO;
    }
    return _content;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end


#pragma mark - NaviMenuObject
////@implementation NaviMenuObject
//
//@end

#pragma mark - PublisherObject
@implementation PublisherObject

@end

#pragma mark - LikerObject
@implementation LikerObject

@end

#pragma mark - commentObject
@implementation commentObject

@end
