//
//  CHImagePublishBaseViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/25.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHImagePublishBaseViewController.h"
#import "CHImagePickerSheet.h"
#import "CHImageManagerCollectionViewCell.h"
#import "JJPhotoManeger.h"

@interface CHImagePublishBaseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CHImagePickerSheetDelegate>
/**
 * 图片名称
 */
@property (nonatomic, copy) NSString *pushImageName;;
/**
 * 添加图片提示
 */
@property (nonatomic, strong)UILabel *addImageLabel;
@property (nonatomic, strong)CHImagePickerSheet *imagePickerSheet;

@end

static NSString *const reuserIndentifier = @"collectionViewCell";
@implementation CHImagePublishBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化collectionView
- (void)initPickerView
{
    _showActionSheetViewController = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    if (_showInView) {
        [_showInView addSubview:self.pickerCollectionView];
    } else {
        [self.view addSubview:self.pickerCollectionView];
    }
    self.pickerCollectionView.delegate = self;
    self.pickerCollectionView.dataSource = self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    if (_imageArray.count == 0) {
        _imageArray = [NSMutableArray array];
    }
    if (_bigImageArray.count == 0) {
        _bigImageArray = [NSMutableArray array];
    }
    self.pushImageName = @"plus";
    _pickerCollectionView.scrollEnabled = NO;
    
    //上传图片提示
    _addImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 70, 20)];
    _addImageLabel.text = @"上传图片";
    _addImageLabel.textColor = [UIColor groupTableViewBackgroundColor];
    [self.pickerCollectionView addSubview:_addImageLabel];
}

#pragma mark UIcollectionview.delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count + 1;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (kScreenWidth - 64) / 4;
    return CGSizeMake(itemW ,itemW);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 8, 20, 8);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerNib: [UINib nibWithNibName:@"CHImageManagerCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuserIndentifier];
    CHImageManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIndentifier forIndexPath:indexPath];
    if (indexPath.row == _imageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:self.pushImageName]];
        cell.cancleButton.hidden = YES;
        //没有任何图片
        if (_imageArray.count == 0) {
            _addImageLabel.hidden = NO;
        } else {
            _addImageLabel.hidden = YES;
        }
    } else {
        [cell.profilePhoto setImage:_imageArray[indexPath.item]];
        cell.cancleButton.hidden = NO;
    }
    [cell setBigImageViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    cell.profilePhoto.userInteractionEnabled = YES;
    [cell.profilePhoto addGestureRecognizer:tap];
    cell.cancleButton.tag = [indexPath item];
    [cell.cancleButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self changeCollectionViewHeight];
    
    return cell;
}

#pragma mark - 图片的点击事件
- (void)tapProfileImage:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    UIImageView *tableGridImage = (UIImageView *)tap.view;
    NSInteger Index = tableGridImage.tag;
    
    if (Index == _imageArray.count) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImage];
    } else { //点击放大
        CHImageManagerCollectionViewCell *cell = (CHImageManagerCollectionViewCell *)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:Index inSection:0]];
        if (!cell.bigImageView || !cell.bigImageView.image) {
            [cell setBigImageViewWithImage:[self getBigImageWithALAsset:_arrSelected[Index]]];
        }
        
    }
}

- (void)deletePhoto:(UIButton *)btn
{
    [_imageArray removeObjectAtIndex:btn.tag];
    [_arrSelected removeObjectAtIndex:btn.tag];
    
    [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:btn.tag inSection:0]]];
    for (NSInteger item = btn.tag; item <= _imageArray.count; item++) {
        CHImageManagerCollectionViewCell *cell = (CHImageManagerCollectionViewCell *)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.cancleButton.tag--;
        cell.profilePhoto.tag--;
    }
    [self changeCollectionViewHeight];
}

#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight
{
    CGFloat collectionHeight = ((kScreenWidth - 64) / 4 + 20) * (int)(_arrSelected.count / 4 + 1 + 20);
    if (_collectionFrameY) {
        _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, kScreenWidth, collectionHeight);
    } else {
        _pickerCollectionView.frame = CGRectMake(0, 0, kScreenWidth, collectionHeight);
    }
    [self pickerViewFrameChanged];
}

- (UIImage *)getBigImageWithALAsset:(ALAsset *)set
{
    //压缩
    //需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage scale:set.defaultRepresentation.scale orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    [_bigImageArray addObject:imageData];
    return [UIImage imageWithData:imageData];
}

- (void)addNewImage
{
    if (!_imagePickerSheet) {
        _imagePickerSheet = [CHImagePickerSheet new];
        _imagePickerSheet.delegate = self;
    }
    
    if (_arrSelected) {
        _imagePickerSheet.arrSelected = _arrSelected;
    }
    
    _imagePickerSheet.maxCount = _maxCount;
    [_imagePickerSheet showImagePickerActionSheetView:_showActionSheetViewController];
}

#pragma mark - 相册完成选择得到的图片
- (void)getSelectImageWithAlAssetAArray:(NSArray *)AlAssetArray thumbnailImageArray:(NSArray *)thumnailImageArray
{
    _arrSelected = [NSMutableArray arrayWithArray:AlAssetArray];
    _imageArray = [NSMutableArray arrayWithArray:thumnailImageArray];
    [self.pickerCollectionView reloadData];
}

- (void)pickerViewFrameChanged
{
    
}

- (void)updatePickerViewFrameY:(CGFloat)Y
{
    _collectionFrameY = Y;
    CGFloat collectionHeight = ((kScreenWidth - 64) / 4 + 20) * (int)(_arrSelected.count / 4 + 1 + 20);
    _pickerCollectionView.frame = CGRectMake(0, Y, kScreenWidth, collectionHeight);
}

#pragma mark - 防止崩溃处理
- (void)photoViewerWilldealloc:(NSInteger)selectImageViewIndex
{
    NSLog(@"最后一张观看的图片是%zd", selectImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

- (NSArray *)getBigImageArrayWithALAssetArray:(NSArray *)ALAssetArray
{
    _bigImageArray = [NSMutableArray array];
    NSMutableArray *bigImgArr = [NSMutableArray array];
    for (ALAsset *set in ALAssetArray) {
        [bigImgArr addObject:[self getBigImageWithALAsset:set]];
    }
    _bigImageArray = bigImgArr;
    return _bigImageArray;
}

#pragma mark 获取选中图片的各个尺寸
- (NSArray *)getALAssetArray
{
    return _arrSelected;
}

- (NSArray *)getBigImageArray
{
    return [self getBigImageArrayWithALAssetArray:_arrSelected];
}

- (NSArray *)getSmallImageArray
{
    return _imageArray;
}

- (CGRect)getPickerViewFrame
{
    return self.pickerCollectionView.frame;
}

@end
