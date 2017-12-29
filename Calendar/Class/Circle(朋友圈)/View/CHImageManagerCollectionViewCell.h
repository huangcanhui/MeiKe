//
//  CHImageManagerCollectionViewCell.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/25.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHImageManagerCollectionViewCell : UICollectionViewCell
/**
 * 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
/**
 * 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (nonatomic, strong)UIImageView *bigImageView;
/**
 * 查看大图
 */
- (void)setBigImageViewWithImage:(UIImage *)image;
@end
