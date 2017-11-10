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
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 10, frame.size.height / 2)];
    textView.delegate = self;
    [self addSubview:textView];
}

#pragma mark UITextView.delegate
- (void)textViewDidChange:(UITextView *)textView
{
    
}

@end
