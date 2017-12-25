//
//  CHPublishView.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPublishView.h"
#import "CHImagePublishBaseViewController.h"

@interface CHPublishView ()<UITextViewDelegate>
//@property (nonatomic, strong)UIView *photoView;
//@property (nonatomic, strong)UITextView *textView;
@end

@implementation CHPublishView

- (CHPublishView *)initWithFrame:(CGRect)frame andStyle:(viewsStyle)style
{
    CHPublishView *publishView = [[CHPublishView alloc] initWithFrame:frame];
    publishView.backgroundColor = HexColor(0xffffff);
    CGFloat buttonW;
    if (style == viewWithTextAndPhoto) {
        buttonW = (frame.size.width - 16 * 4) / 4;
        UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - buttonW - 16, kScreenWidth, buttonW + 16)];
        
        [publishView addSubview:photoView];
    } else {
        buttonW = 0;
    }
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, frame.size.width - 16, frame.size.height - buttonW - 16)];
    textView.delegate = self;
    //外框的样式
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 5;
    [publishView addSubview:textView];
    
    return publishView;
}

#pragma mark UITextView.delegate
- (void)textViewDidChange:(UITextView *)textView
{
    //获取用户写入的文字
    if (self.getData) {
        self.getData(textView.text);
    }
}

@end
