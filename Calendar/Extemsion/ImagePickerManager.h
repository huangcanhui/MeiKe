//
//  ImagePickerManager.h
//  YMStars
//
//  Created by HFY on 2017/9/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 宏定义单例模式，方便外界调用
 */
#define UploadImage [ImagePickerManager shareUploadImage]

/**
 * 代理方法
 */
@protocol ImagePickerManagerDelegate <NSObject>

@optional
/**
 * 在这边进行图片处理
 */
- (void)uploadImageToServerWithImage:(NSString *)imageName;

@end

@interface ImagePickerManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak)id <ImagePickerManagerDelegate>uploadImageDelegate;

@property (nonatomic, strong)UIViewController *superViewController;

/**
 * 单例方法
 */
+ (ImagePickerManager *)shareUploadImage;

/**
 * 弹框的方法
 */
- (void)showActionSheetInSuperViewController:(UIViewController *)superViewController delegate:(id<ImagePickerManagerDelegate>)delegate;

@end
