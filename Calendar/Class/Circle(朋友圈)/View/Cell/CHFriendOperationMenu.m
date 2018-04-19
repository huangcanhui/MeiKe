//
//  CHFriendOperationMenu.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/18.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendOperationMenu.h"
#import "UIView+SDAutoLayout.h"

@implementation CHFriendOperationMenu
{
    UIButton *_likeButton;
    UIButton *_commentButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = HexColor(0x433f3f);
    
    _likeButton = [self createButtonWithTitle:@"赞" image:[UIImage imageNamed:@"circle_like"] selectImage:[UIImage imageNamed:@""] target:self select:@selector(likeButtonClicked)];
    _commentButton = [self createButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selectImage:[UIImage imageNamed:@""] target:self select:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 5;
    
    _likeButton.sd_layout.leftSpaceToView(self, margin).topEqualToView(self).bottomEqualToView(self).widthIs(80);
    
    centerLine.sd_layout.leftSpaceToView(_likeButton, margin).topSpaceToView(self, margin).bottomEqualToView(self).widthIs(1);
    
    _commentButton.sd_layout.leftSpaceToView(centerLine, margin).topEqualToView(_likeButton).bottomEqualToView(_likeButton).widthRatioToView(_likeButton, 1);
}

- (UIButton *)createButtonWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage target:(id)target select:(SEL)select
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectImage forState:UIControlStateSelected];
    [btn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOPeration) {
        self.likeButtonClickedOPeration();
    }
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickOperation) {
        self.commentButtonClickOperation();
    }
    self.show = NO;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            [self clearAutoWidthSettings];
            self.fixedWidth = @(0);
        } else {
            self.fixedWidth = nil;
            [self setupAutoWidthWithRightView:_commentButton rightMargin:5];
        }
        //更新cell内部的控件布局（cell内部控件专属的更新约束方法。如果启用了cell frame缓存则会自动清除缓存再更新约束）
        [self updateLayoutWithCellContentView:self.superview];
    }];
}

@end
