//
//  CH_ImageAndContent_SectionHeader.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CH_ImageAndContent_SectionHeader.h"

@implementation CH_ImageAndContent_SectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = HexColor(0xffffff);
    CGFloat margin = 8;
    CGFloat height = self.frame.size.height - 2 * margin;
    
    UIView *mainView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:mainView];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, height, height)];;
    _imageView = imageV;
    [mainView addSubview:imageV];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageV.CH_right + 5, margin, 2 * self.frame.size.width / 3, height)];
    _titleLabel = label;
    label.textColor = HexColor(0x000000);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15];
    [mainView addSubview:label];
    
    UIImageView *arrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 25, 14, 20, 20)];
    arrImageView.image = [UIImage imageNamed:@"arrow_right_gray"];
    [mainView addSubview:arrImageView];
}
@end

NSString *const CHImageAndContentSectionHeaderIdentifier = @"CH_ImageAndContent_SectionHeader";
