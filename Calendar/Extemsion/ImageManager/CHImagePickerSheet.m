//
//  CHImagePickerSheet.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/25.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHImagePickerSheet.h"
#import "MImaLibTool.h"
#import "MShowAllGroup.h"

@interface CHImagePickerSheet ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, MShowAllGroupDelegate>

@end

@implementation CHImagePickerSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
    }
    return self;
}

//显示选择照片提示sheet
- (void)showImagePickerActionSheetView:(UIViewController *)controller
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!imagePicker) {
            imagePicker = [UIImagePickerController new];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [viewController presentViewController:imagePicker animated:NO completion:nil];
        }
    }];
    UIAlertAction *alertAlbum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImageDataAndShowAllGroup];
    }];
    [alertController addAction:alertCancel];
    [alertController addAction:alertCamera];
    [alertController addAction:alertAlbum];
    viewController = controller;
    [viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 加载照片数据
- (void)loadImageDataAndShowAllGroup
{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if (self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (_arrSelected) {
                    svc.arrSeleted = _arrSelected;
                    svc.mvc.arrSelected = _arrSelected;
                }
                svc.maxCout = _maxCount;
                [viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}


#pragma mark - 拍照获得数据
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *theImage = nil;
    //判断图片是否允许修改
    if ([picker allowsEditing]) {
        //获取用户编辑后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        //照片的源数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (theImage) {
        //保存到相册中
        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
        [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                
            } else {
                //获取图片路径
                [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        [_arrSelected addObject:asset];
                        [self finishSelectImg];
                        [picker dismissViewControllerAnimated:NO completion:nil];
                    }
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }];
    }
}

#pragma mark - 完成后返回的图片array
- (void)finishSelectImg
{
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    for (ALAsset *set in _arrSelected) {
        CGImageRef cgimg = [set thumbnail];
        UIImage *image = [UIImage imageWithCGImage:cgimg];
        [thumbnailImgArr addObject:image];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithAlAssetAArray:thumbnailImageArray:)]) {
        [self.delegate getSelectImageWithAlAssetAArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
    }
}

@end
