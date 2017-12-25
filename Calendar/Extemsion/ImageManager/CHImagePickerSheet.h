//
//  CHImagePickerSheet.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/25.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 这是一个枚举类型
 * 枚举图片选出的方式
 */
typedef enum {
    selectSend = 1,
    selectCancel = 2,
    selectCamera = 3,
    selectPhotoLib = 4
}menuSelectedType;
/**
 * 定义选择的block方法
 */
typedef void(^menuSelectblock)(id obj, menuSelectedType type);
/**
 * 代理协议
 */
@protocol CHImagePickerSheetDelegate <NSObject>

@optional

/**
 * 相册完成选择得到的图片
 */
- (void)getSelectImageWithAlAssetAArray:(NSArray *)AlAssetArray thumbnailImageArray:(NSArray *)thumnailImageArray;

@end

@interface CHImagePickerSheet : NSObject
{
    UIImagePickerController *imagePicker;
    UIViewController *viewController;
}
/**
 * 代理协议
 */
@property (nonatomic, assign)id <CHImagePickerSheetDelegate>delegate;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *arrTitles;
@property (nonatomic, copy)menuSelectblock menuBlock;
@property (nonatomic, strong)NSArray *arrGroup;
@property (nonatomic, strong)NSMutableArray *arrSelected;
@property (nonatomic, assign)NSInteger maxCount;
/**
 * 显示选择照片提示sheet
 */
- (void)showImagePickerActionSheetView:(UIViewController *)controller;

@end
