//
//  CHUpdataPhotoViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/15.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHUpdataPhotoViewController.h"

#import "CHImageManagerCollectionViewCell.h"
#import "WPhotoViewController.h"
#import "CHTime.h"
#import "CHNormalButton.h"
#import "Masonry.h"

static NSString *bundleID = @"bundleID";
static NSString *headerID = @"header";
static CGFloat Maigin = 10.0f;
@interface CHUpdataPhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/**
 * 提示视图
 */
@property (nonatomic, strong)UIView *cueView;
/**
 * UICollectionView
 */
@property (nonatomic, strong)UICollectionView *collectionView;
/**
 * UICollectionViewFlowLayout
 */
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
/**
 * 数据源
 */
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *arrayM; //中间键
@end

@implementation CHUpdataPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.title = @"上传照片";
    
    [self initAttribute];
    
    [self.view addSubview:self.cueView];
    
    [self.view addSubview:self.collectionView];
    
    [self createPublishButton];
}

#pragma mark - 初始化一些数据
- (void)initAttribute
{
    _arrayM = [NSMutableArray array];
    
    _photoArray = [NSMutableArray array];
}

#pragma mark - 添加提示
- (UIView *)cueView
{
    if (!_cueView) {
        _cueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _cueView.backgroundColor = HexColor(0xffffff);
        UILabel *label = [[UILabel alloc] initWithFrame:_cueView.bounds];
        label.text = @"目前仅支持图片上传,视频部分攻城狮正在努力攻坚中";
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [_cueView addSubview:label];
    }
    return _cueView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.cueView.CH_bottom, kScreenWidth, screenWithoutTopbar - self.cueView.CH_height - 55) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexColor(0xffffff);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, navigationHeight, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"CHImageManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bundleID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kScreenWidth - 64) / 4;;
        //设置单元格大小
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        //最小行间距
        _flowLayout.minimumLineSpacing = 0;
        //设置section的内边距
        _flowLayout.sectionInset = UIEdgeInsetsMake(Maigin, Maigin, Maigin, Maigin);
        //设置UICollectionView的滑动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //sectionheader的大小
        _flowLayout.headerReferenceSize = CGSizeMake(0, 45);
    }
    return _flowLayout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count + 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:header.bounds];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        NSArray *array = [[CHTime getCurrentTimes] componentsSeparatedByString:@" "];
        label.text = array[0];
        [header addSubview:label];
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHImageManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bundleID forIndexPath:indexPath];
    if (indexPath.row == _photoArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:@"plus"]];
        cell.cancleButton.hidden = YES;
    } else {
        [cell.profilePhoto setImage:[_photoArray[indexPath.row] objectForKey:@"image"]];
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


- (void)tapProfileImage:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger index = imageView.tag;
    if (index == _photoArray.count) {
        [self addMewImage];
    } else { //点击放大
        
    }
}

#pragma mark 图片的删除事件
- (void)deletePhoto:(UIButton *)btn
{
    [_photoArray removeObjectAtIndex:btn.tag];
    [self.collectionView reloadData];
}

#pragma mark - 添加图片
- (void)addMewImage
{
    weakSelf(wself);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"图片上传" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WPhotoViewController *wphotoVC = [[WPhotoViewController alloc] init];;
        wphotoVC.selectPhotoOfMax = 50; //可以选择的最大张数
        [wphotoVC setSelectPhotosBack:^(NSMutableArray *photosArr) {
            [_photoArray addObjectsFromArray:photosArr];
            [wself.collectionView reloadData];
        }];
        [wself presentViewController:wphotoVC animated:YES completion:nil];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {            }]];
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (void)createPublishButton
{
    CHNormalButton *button = [CHNormalButton title:@"发布" titleColor:HexColor(0xffffff) font:16 aligment:NSTextAlignmentCenter backgroundcolor:GLOBAL_COLOR andBlock:^(CHNormalButton *button) {
 
    }];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(screenWithoutTopbar - 45 - tabbarHeight);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
