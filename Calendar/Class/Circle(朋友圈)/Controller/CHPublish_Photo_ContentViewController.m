//
//  CHPublish_Photo_ContentViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/28.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPublish_Photo_ContentViewController.h"

#import "CHPublish.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "CHNormalButton.h"
#import "ProgressHUD.h"
#import "CH_ImageAndContent_SectionHeader.h"
#import "UIImagePickerController+ST.h"
#import "QNUploadData.h"

#import "CHMapSupportViewController.h"
#import "CHImageManagerCollectionViewCell.h"
#import "WPhotoViewController.h"

static NSString *const bundleID = @"CollectionView";

@interface CHPublish_Photo_ContentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * UICollectionView
 */
@property (nonatomic, strong)UICollectionView *collectionView;
/**
 * UICollectionViewFlowLayout
 */
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
/**
 * 头视图
 */
@property (nonatomic, strong)UIView *headerView;
/**
 * UITextView
 */
@property (nonatomic, strong)UITextView *textView;
/**
 * 输入框的placehold
 */
@property (nonatomic, copy)NSString *placeString;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *data;
/**
 * 中间键
 */
@property (nonatomic, strong)NSMutableArray *selectArrayM;
/**
 * 图片大小
 */
@property (nonatomic, assign)CGFloat itemW;
///**
// * 图片数组
// */
//@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation CHPublish_Photo_ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"发表";
    
    [self initAttribute];
    
    if (self.type == typeWithPhotoAndContent) { //图文
        [self.view addSubview:self.collectionView];
    } else { //单纯文字
        [self.view addSubview:self.tableView];
    }
    
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackCircleVC)];
    
    [self createPublishButton];
}

#pragma mark - 初始化数据
- (void)initAttribute
{
    self.placeString = @"请输入您想发表的心情";
    
    _flowLayout = [UICollectionViewFlowLayout new];
    
    _itemW = (kScreenWidth - 64) / 4;
    
//    _imageArray = [NSArray array];
    
    _selectArrayM = [NSMutableArray array];
}

#pragma mark - 懒加载
/***************************************** 发表文字说说 **********************************************************/
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, screenWithoutTopbar - 45) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark UITableView.delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPublish *publish = self.data[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Publish"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Publish"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.57 alpha:1];
    cell.textLabel.text = publish.title;
    cell.detailTextLabel.text = publish.subTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:publish.icon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { //我的位置
        CHMapSupportViewController *mapVC = [CHMapSupportViewController new];
        mapVC.whenAddressGet = ^(Address *address) {
            
        };
        [self.navigationController pushViewController:mapVC animated:NO];
    } else {
        NSLog(@"其余的");
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, screenWithoutTopbar - tabbarHeight - 50) collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = HexColor(0xffffff);
        _flowLayout.minimumLineSpacing = 0; //行间距
        _flowLayout.minimumInteritemSpacing = 8; //cell间距
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"CHImageManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bundleID];
        //注册头视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"View"];
        [_collectionView registerClass:[CH_ImageAndContent_SectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CHImageAndContentSectionHeaderIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"View"];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.data.count + 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) { //图片
        return _selectArrayM.count + 1;
    } else {
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemW, _itemW);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, DDRealValue(156));
    } else if (section == 1) {
        return CGSizeMake(kScreenWidth, 0);
    } else {
        return CGSizeMake(kScreenWidth, 48);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 0);
    } else {
        return CGSizeMake(kScreenWidth, 8);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) { //文字输入
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"View" forIndexPath:indexPath];
            [view addSubview:self.headerView];
            return view;
        } else { //选择
            CHPublish *publish = self.data[indexPath.section - 2];
            CH_ImageAndContent_SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHImageAndContentSectionHeaderIdentifier forIndexPath:indexPath];
            header.imageView.image = [UIImage imageNamed:publish.icon];
            header.titleLabel.text = publish.title;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publishViewClick:)];
            header.tag = indexPath.section;
            header.userInteractionEnabled = YES;
            [header addGestureRecognizer:tap];
            return header;
        }
    } else {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"View" forIndexPath:indexPath];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHImageManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bundleID forIndexPath:indexPath];
    if (indexPath.row == _selectArrayM.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:@"plus"]];
        cell.cancleButton.hidden = YES;
    } else {
        [cell.profilePhoto setImage:[_selectArrayM[indexPath.row] objectForKey:@"image"]];
        cell.cancleButton.hidden = NO;
    }
    //在这边添加图片的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    cell.profilePhoto.userInteractionEnabled = YES;
    cell.profilePhoto.tag = [indexPath item];
    [cell.profilePhoto addGestureRecognizer:tap];
    
    cell.cancleButton.tag = [indexPath item];
    [cell.cancleButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

#pragma mark - 各种点击事件
#pragma mark 位置的点击事件
- (void)publishViewClick:(UITapGestureRecognizer *)tap
{
    CH_ImageAndContent_SectionHeader *view = (CH_ImageAndContent_SectionHeader *)tap.view;
    NSInteger index = view.tag;
    NSLog(@"%ld", index);
    switch (index) {
        case 2:
        {
            CHMapSupportViewController *mapVC = [CHMapSupportViewController new];
            mapVC.whenAddressGet = ^(Address *address) {
                
            };
            [self.navigationController pushViewController:mapVC animated:NO];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 图片的点击事件
- (void)tapProfileImage:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger index = imageView.tag;
    if (_selectArrayM.count >= 9) {
        [ProgressHUD showError:@"很抱歉！一次最多上传九张照片"];
    } else {
        if (index == _selectArrayM.count) {
            [self addNewImage];
        } else { //点击放大
            
        }
    }
}

#pragma mark 图片的删除事件
- (void)deletePhoto:(UIButton *)btn
{
    [_selectArrayM removeObjectAtIndex:btn.tag];
    [self.collectionView reloadData];
}

#pragma mark - 添加图片
- (void)addNewImage
{
    weakSelf(wself);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"图片上传" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself imagePickerWithPhoto];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WPhotoViewController *wphotoVC = [[WPhotoViewController alloc] init];;
        wphotoVC.selectPhotoOfMax = 9 - _selectArrayM.count; //可以选择的最大张数
        [wphotoVC setSelectPhotosBack:^(NSMutableArray *photosArr) {
            [_selectArrayM addObjectsFromArray:photosArr];
            [wself.collectionView reloadData];
        }];
        [wself presentViewController:wphotoVC animated:YES completion:nil];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

/************************************************  通用部分 *********************************************************/
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, DDRealValueBy6s(168))];
        _headerView.backgroundColor = HexColor(0xffffff);
        [_headerView addSubview:self.textView];
    }
    return _headerView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, kScreenWidth - 16, DDRealValueBy6s(156))];
        
        _textView.delegate = self;
        _textView.text = self.placeString;
        _textView.textColor = [UIColor grayColor];
        _textView.font = [UIFont systemFontOfSize:13];
        //外框的样式
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 5;
    }
    return _textView;
}

#pragma mark UITextView.delegate
- (void)textViewDidChange:(UITextView *)textView
{

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:self.placeString]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeString;
        textView.textColor = [UIColor grayColor];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textView endEditing:YES];
}

#pragma mark - 从相机获取图片
- (void)imagePickerWithPhoto
{
    weakSelf(wself);
    UIImagePickerController *picker = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.navigationBar.translucent = NO;
    picker.navigationBar.barTintColor = GLOBAL_COLOR;
    picker.allowsEditing = YES;
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(0xffffff)}];
    if ([picker isAvailableCamera] && [picker isSupportTakingPhotos]) {
        [picker setDelegate:wself];
        [wself presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:resultImage forKey:@"image"];
    [_selectArrayM addObject:dict];
    [self.collectionView reloadData];
}

#pragma mark - 数据源
- (NSArray *)data
{
    if (!_data) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CHPublish" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _data = [CHPublish mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _data;
}

#pragma mark - 发布按钮
- (void)createPublishButton
{
    CHNormalButton *button = [CHNormalButton title:@"发布" titleColor:HexColor(0xffffff) font:16 aligment:NSTextAlignmentCenter backgroundcolor:GLOBAL_COLOR andBlock:^(CHNormalButton *button) {
        [QNUploadData uploadDataFile:[_selectArrayM copy]];
    }];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(screenWithoutTopbar - 45 - tabbarHeight);
    }];
}

#pragma mark - 返回按钮的点击事件
- (void)clickBackCircleVC
{
    //判断用户是否已经有输入
    if (![self.textView.text isEqualToString:self.placeString] || _selectArrayM.count != 0) {
        [self alertWithTitle:@"提示" message:@"您编辑的说说还未发布，确认离开？" cancelTitle:@"取消" otherTitles:@"离开" block:^{
           [self dismissViewControllerAnimated:NO completion:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


@end
