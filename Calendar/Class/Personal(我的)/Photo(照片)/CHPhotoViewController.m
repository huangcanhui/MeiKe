//
//  CHPhotoViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPhotoViewController.h"

@interface CHPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/**
 * UICollectionView
 */
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@end

static NSString *bundleID = @"photo";
static NSString *headerID = @"header";
static CGFloat Maigin = 10.0f;
@implementation CHPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"我的照片";
    
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexColor(0xffffff);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, navigationHeight, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bundleID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kScreenWidth - 4 * Maigin) / 3;
        //设置单元格大小
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        //最小行间距
        _flowLayout.minimumLineSpacing = 10;
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
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        headerView.backgroundColor = [UIColor blueColor];
        [header addSubview:headerView];
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bundleID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

//选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击第%ld组第%ld行", (long)indexPath.section, (long)indexPath.row);
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
