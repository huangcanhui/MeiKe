//
//  CHFriendPhotoContainerView.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/12.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendPhotoContainerView.h"

#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "CHNetString.h"

@interface CHFriendPhotoContainerView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong)NSArray *imageViewsArray;

@end

@implementation CHFriendPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    self.imageViewsArray = [temp copy];
}

#pragma mark - 图片的点击事件
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picPathStringArray.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowser.delegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

- (void)setPicPathStringArray:(NSArray *)picPathStringArray
{
    _picPathStringArray = picPathStringArray;
    
    for (long i = _picPathStringArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return ;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringArray];
    CGFloat itemH = 0;
    if (_picPathStringArray.count == 1) {
        UIImage *image = [UIImage imageNamed:_picPathStringArray.firstObject];
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringArray];
    CGFloat margin = 5;
    
    [_picPathStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
//        imageView.image = [UIImage imageNamed:obj];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:obj]] placeholderImage:[UIImage imageNamed:@"LOGO"]];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(self.picPathStringArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWith = @(w);
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = kScreenWidth > 375 ? 80 : 70;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

@end
