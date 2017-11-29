//
//  ImagePickerManager.m
//  YMStars
//
//  Created by HFY on 2017/9/6.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "ImagePickerManager.h"
#import "CHAlertViewManager.h"

#import "UIImagePickerController+ST.h"
#import "CHManager.h"
#import "QiniuSDK.h"
#import "HappyDNS.h"
#import "ProgressHUD.h"

static ImagePickerManager *pickerManager = nil;

@implementation ImagePickerManager

+ (ImagePickerManager *)shareUploadImage
{
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        pickerManager = [[ImagePickerManager alloc] init];
    });
    return pickerManager;
}


- (void)showActionSheetInSuperViewController:(UIViewController *)superViewController delegate:(id<ImagePickerManagerDelegate>)delegate
{
    pickerManager.uploadImageDelegate = delegate;
    
    self.superViewController = superViewController;
    
    [CHAlertViewManager actionSheettWithTitle:@"图片上传" message:@"" actionNumber:3 actionTitles:@[@"相机", @"图库", @"取消"] actionHandler:^(UIAlertAction *action, NSUInteger index) {
        if (index == 0) { //相机
            [self imagePickeWithPhoto];
        } else if (index == 1) { //图库
            [self imagePickerWithLibrary];
        } else {
            
        }
    }];
}

#pragma mark 从相机获取
- (void)imagePickeWithPhoto
{
    UIImagePickerController *picker = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.navigationBar.translucent = NO;
    picker.navigationBar.barTintColor = GLOBAL_COLOR;
    picker.allowsEditing = YES;
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(0xffffff)}];
    if ([picker isAvailableCamera] && [picker isSupportTakingPhotos]) {
        [picker setDelegate:self];
        [_superViewController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
    }
}

#pragma mark  从图库中
- (void)imagePickerWithLibrary
{
    UIImagePickerController *picker = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    picker.navigationBar.translucent = NO;
    picker.navigationBar.barTintColor = GLOBAL_COLOR;
    picker.allowsEditing = YES;
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(0xffffff)}];
    if ([picker isAvailablePhotoLibrary]) {
        [picker setDelegate:self];
        [_superViewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //给图片创建一个唯一的名称
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@", str];
    NSData *data = UIImagePNGRepresentation(resultImage);
    //获取七牛的uptoken
//    [SVProgressHUD showWithStatus:@"图片上传中，请稍后..."];
//    [ show:@"图片上传中，请稍后..."];
    NSString *path = NSLocalizedStringFromTable(@"activity_Uptoken_Url", @"IndexURL", nil);
    [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            NSMutableArray *arrayM = [NSMutableArray array];
            [arrayM addObject:[QNResolver systemResolver]];
            QNDnsManager *dns = [[QNDnsManager alloc] init:arrayM networkInfo:[QNNetworkInfo normal]];
            //是否选择HTTPS上传
//            builder.zone = [[QNAutoZone alloc] initWithHttps:YES dns:dns];
            builder.zone = [[QNAutoZone alloc] initWithDns:dns];
        }];
        QNUploadManager *manager = [[QNUploadManager alloc] initWithConfiguration:config];
        [manager putData:data key:fileName token:dic[@"uptoken"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:)]) {
                [self.uploadImageDelegate uploadImageToServerWithImage:resp[@"key"]];
//                [ProgressHUD showSuccess:@"图片上传成功!"];
                
            }
        } option:nil];
    } WithFailurBlock:^(NSError *error) {
//        [ProgressHUD showError:@"图片上传失败"];
    }];
}

@end
