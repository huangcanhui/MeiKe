//
//  CHImageManagerCollectionViewCell.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/25.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHImageManagerCollectionViewCell.h"

@implementation CHImageManagerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBigImageViewWithImage:(UIImage *)image
{
    if (_bigImageView) {
        //如果大图正在显示，还原小图
        _bigImageView.frame = _profilePhoto.frame;
        _bigImageView.image = image;
    } else {
        _bigImageView = [[UIImageView alloc] initWithImage:image];
        _bigImageView.frame = _profilePhoto.frame;
        [self insertSubview:_bigImageView atIndex:0];
    }
    
    _bigImageView.contentMode = UIViewContentModeScaleToFill;
}

@end
