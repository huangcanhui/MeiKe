//
//  CH_ImageAndContent_SectionHeader.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/29.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CH_ImageAndContent_SectionHeader : UICollectionReusableView
/**
 * 图标
 */
@property (nonatomic, strong)UIImageView *imageView;
/**
 * 标题
 */
@property (nonatomic, strong)UILabel *titleLabel;

@end

FOUNDATION_EXPORT NSString *const CHImageAndContentSectionHeaderIdentifier;
