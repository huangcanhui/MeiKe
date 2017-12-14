//
//  CHTimeShowView.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/14.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHTimeShowView.h"

@interface CHTimeShowView ()
/**
 * UILabel
 */
@property (nonatomic, strong)UILabel *label;

@end

@implementation CHTimeShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = HexColor(0xffffff);
    self.label.font = [UIFont boldSystemFontOfSize:20];
    self.label.numberOfLines = 0;
    [self addSubview:self.label];
    
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.backgroundColor = HexColor(0x000000);
    self.alpha = 0.6;
}

- (void)setText:(NSString *)text
{
    NSArray *array = [text componentsSeparatedByString:@" "];
    NSString *string = [NSString stringWithFormat:@"我的时光旅程:\n%@",array[0]];
    self.label.text = string;
    if (!self.label) {
        [self insertSubview:self.label atIndex:1];
    }
}

@end
