//
//  CHBarButtonItem.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHBarButtonItem.h"

@interface CHBarButtonItem ()

@property (nonatomic, strong)UILabel *titleText;

@end

@implementation CHBarButtonItem

- (CHBarButtonItem *)initWithLeftBarButton:(NSString *)title target:(id)target action:(SEL)method
{
    CGRect titleFrame = CGRectMake(15, 4, 85, 17);
    if (title.length == 0) {
        titleFrame = CGRectZero;
    }
    return [self initContainImage:[UIImage imageNamed:@"arrow_left_white"] imageViewFrame:CGRectMake(0, 4, 10, 17) buttonTitle:title titleColor:HexColor(0x000000) titleFrame:CGRectMake(15, 4, 85, 17) buttonFrame:CGRectMake(-4, 0, 87, 23) target:target action:method];
}

- (CHBarButtonItem *)initContainImage:(UIImage *)buttonImage imageViewFrame:(CGRect)imageFrame buttonTitle:(NSString *)buttonTitle titleColor:(UIColor *)titleColor titleFrame:(CGRect)titleFrame buttonFrame:(CGRect)buttonFrame target:(id)target action:(SEL)method
{
    self = [[CHBarButtonItem alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:buttonFrame];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = buttonFrame;
    UIImageView *image = [[UIImageView alloc] initWithImage:buttonImage];
    image.frame = imageFrame;
    [self.button addSubview:image];
    
    if (buttonTitle != nil && titleColor != nil) {
        self.titleText = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleText.text = buttonTitle;
        [self.titleText setBackgroundColor:[UIColor clearColor]];
        [self.titleText setTextColor:titleColor];
        [self.button addSubview:self.titleText];
    }
    
    [self.button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:method];
    [view addGestureRecognizer:tap];
    self.customView = view;
    return self;
}

- (CHBarButtonItem *)initWithButtonTitle:(NSString *)buttonTitle titleColor:(UIColor *)titleColor buttonFrame:(CGRect)buttonFrame target:(id)target action:(SEL)method
{
    self = [[CHBarButtonItem alloc] init];
    self.button = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.button setTitleColor:titleColor forState:UIControlStateNormal];
    [self.button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    self.customView = self.button;
    return self;
}

- (void)buttonIsCanClick:(BOOL)isCanClick buttonColor:(UIColor *)buttonColor barButtonItem:(CHBarButtonItem *)barButtonItem
{
    if (isCanClick == YES) {
        barButtonItem.customView.userInteractionEnabled = YES;
    } else {
        barButtonItem.customView.userInteractionEnabled = NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (buttonColor != nil) {
            if (barButtonItem.titleText != nil) {
                [barButtonItem.titleText setTextColor:buttonColor];
            } else {
                [barButtonItem.button setTitleColor:buttonColor forState:UIControlStateNormal];
                barButtonItem.customView = barButtonItem.button;
            }
        }
    });
}

- (NSArray<UIBarButtonItem *> *)setTranslation:(UIBarButtonItem *)barButtonItem translation:(CGFloat)translation
{
    if (barButtonItem == nil) {
        return nil;
    }
    NSArray <UIBarButtonItem *> *barButtonItems;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = translation;
    barButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
    return barButtonItems;
}
@end
