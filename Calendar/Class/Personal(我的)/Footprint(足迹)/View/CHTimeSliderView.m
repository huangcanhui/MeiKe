//
//  CHTimeSliderView.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/13.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHTimeSliderView.h"

#define kCornerRadius 5.0 //默认圆角
#define kBorderWidth 0.2 //默认的slider边框宽度
#define kSliderWidth 12 //默认的slider的宽度
#define kBackViewColor [UIColor darkGrayColor]

@interface CHTimeSliderView ()
/**
 * UIView
 */
@property (nonatomic, strong)UIView *backView; //背景
@property (nonatomic, strong)UIView *sliderView; //滑动
/**
 * UILabel
 */
@property (nonatomic, strong)UILabel *label;

@end

@implementation CHTimeSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.font = [UIFont systemFontOfSize:15];
    
    self.backView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backView];
    
    self.sliderView = [[UIView alloc] init];
    [self.backView addSubview:self.sliderView];
    
    //默认配置
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = kBorderWidth;
    self.backgroundColor = kBackViewColor;
    [self setSliderValue:self.minValue];
    
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderView:)];
    self.backView.userInteractionEnabled = YES;
    [self.backView addGestureRecognizer:pan];
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
    if (!self.label.superview) {
        [self insertSubview:self.label atIndex:1];
    }
}

- (void)setSliderValue:(CGFloat)value
{
    if (value > self.maxValue) { //如果最大值大于这个
        value = self.maxValue;
    }
    if (value < self.minValue) {
        value = self.minValue;
    }

}

- (void)sliderView:(UIPanGestureRecognizer *)pan
{
    CGPoint original = [pan locationInView:self];
    self.sliderView = pan.view;
    if (self.sliderView.CH_height >= 0 && self.sliderView.CH_height <= self.CH_height) {
        self.sliderView.CH_height = original.y;
        if (original.y >= self.CH_height ) {
            original.y = self.CH_height;
        }
        if (original.y <= 0) {
            original.y = 0;
        }
        self.sliderView.frame = CGRectMake(0, 0, self.CH_width, original.y);
        self.sliderView.backgroundColor = [UIColor orangeColor];
    }
    CGFloat value = (self.maxValue - self.minValue) / self.CH_height;
    if (self.sliderValueChange) {
        if (original.y == 0) {
            self.sliderValueChange([NSString stringWithFormat:@"%f", self.maxValue]);
        } else {
            self.sliderValueChange([NSString stringWithFormat:@"%f", self.maxValue - original.y * value]);
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.gesRecognizerEnd) {
            self.gesRecognizerEnd();
        }
    }
}

- (void)setColorForBackView:(UIColor *)backColor sliderColor:(UIColor *)sliderColor textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor
{
    self.backView.backgroundColor = backColor;
    self.sliderView.backgroundColor = sliderColor;
    self.label.textColor = textColor;
    [self.layer setBorderColor:borderColor.CGColor];
}

@end
