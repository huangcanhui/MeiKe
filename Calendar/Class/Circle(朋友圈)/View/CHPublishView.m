//
//  CHPublishView.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHPublishView.h"

@interface CHPublishView ()<UITextViewDelegate>

@end

@implementation CHPublishView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = HexColor(0xffffff);
        
        [self initTextView:frame];
    }
    return self;
}

- (void)initTextView:(CGRect)frame
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 16)];
    textView.delegate = self;
    //外框的样式
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 5;
    [self addSubview:textView];
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
