//
//  CHImagePublishBaseViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/25.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol CHImagePublishBaseViewControllerDelegate <NSObject>

@optional

@end

@interface CHImagePublishBaseViewController : UIViewController

@property (nonatomic, assign)id <CHImagePublishBaseViewControllerDelegate>delegate;

@property (nonatomic, strong)UICollectionView *pickerCollectionView;

@property (nonatomic, assign)CGFloat collectionFrameY;

/**
 * 选择的图片数据
 */
@property (nonatomic, strong)NSMutableArray *arrSelected;
/**
 * 方形压缩图image数组
 */
@property (nonatomic, strong)NSMutableArray *imageArray;
/**
 * 大图image数组
 */
@property (nonatomic, strong)NSMutableArray *bigImageArray;
/**
 * 大图image数组
 */
@property (nonatomic, strong)NSMutableArray *bigImageDataArray;
/**
 * 图片选择器
 */
@property (nonatomic, strong)UIViewController *showActionSheetViewController;
/**
 * collectionview所在的view
 */
@property (nonatomic, strong)UIView *showInView;
/**
 * 图片的总数限制
 */
@property (nonatomic, assign)NSInteger maxCount;
/**
 * 初始化collectionView
 */
- (void)initPickerView;
/**
 * 修改collectionView的位置
 */
- (void)updatePickerViewFrameY:(CGFloat)Y;
/**
 * 获取collectionView的frame
 */
- (CGRect)getPickerViewFrame;

/**
 * 获取选中的所有图片信息
 */
- (NSArray *)getSmallImageArray;
- (NSArray *)getBigImageArray;
- (NSArray *)getALAssetArray;

- (void)pickerViewFrameChanged;

@end
