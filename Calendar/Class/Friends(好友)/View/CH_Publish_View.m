//
//  CH_Publish_View.m
//  YMStars
//
//  Created by HFY on 2017/8/11.
//  Copyright © 2017年 huangcanhui. All rights reserved.
//

#import "CH_Publish_View.h"
#import "CHImageButton.h"

@implementation CH_Publish_View

+ (CH_Publish_View *)setPublishViewFrame:(CGRect)frame andBackground:(UIColor *)color andTitleArray:(NSArray *)titleArray andImageArray:(NSArray *)imageArray andTitleColor:(UIColor *)titleColor andTitleFont:(int)font andTitleBackground:(UIColor *)titleBackground
{
    CH_Publish_View *view = [[CH_Publish_View alloc] initWithFrame:frame];
    view.backgroundColor = color;
    for (int i = 0; i < titleArray.count; i++) {
        CHImageButton *button = [CHImageButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, frame.size.height / 4 * i, frame.size.width, (frame.size.height - 3) / 4);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:font];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.Scale = 0;
        button.spacing = 0.1;
        button.mode = addButtonLeft;
        button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        button.tag = 100 + i;
        [button addTarget:view action:@selector(clickButtonView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    
    return view;
}


- (void)clickButtonView:(UIButton *)button
{
    if (self.whenButtonClick) {
        self.whenButtonClick(button.tag - 100);
    }
}

+ (CH_Publish_View *)setViewFrame:(CGRect)frame andBackground:(UIColor *)color andSubBackground:(UIColor *)background
{
    CH_Publish_View *view = [[CH_Publish_View alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    CGFloat viewH = frame.size.height / 3;
    for (int i = 0; i < 2; i++) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(8, 8 + 1.5 * viewH * i, frame.size.width - 16, viewH)];
        subView.backgroundColor = background;
        [view addSubview:subView];
    }
    
    
    return view;
}


@end
