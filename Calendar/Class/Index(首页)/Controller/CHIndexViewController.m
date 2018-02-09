//
//  CHIndexViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/24.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHIndexViewController.h"

#import "CH_Publish_View.h"
#import "CHNavigationBar.h"

#import "CHAdd_FriendViewController.h"
#import "CHScanCodeViewController.h"

@interface CHIndexViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/**
 * 计数器
 */
@property (nonatomic, assign)int count;
/**
 * 导航栏右上角视图
 */
@property (nonatomic, strong)CH_Publish_View *publishView;
/**
 * 导航栏
 */
@property (nonatomic, strong)CHNavigationBar *navigationBar;

@end

@implementation CHIndexViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"首页";
    
    [self initAttribute];
    
    [self createCollectionView];
    
    [self addNavigationBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightNavigationItemEvent)];
}

#pragma mark - UICollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, tabbarHeight, 0);
    
    [self.view addSubview:collectionView];
}

#pragma mark UICollectionView.delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
            case 0:
        {
            break;
        }
            case 1:
        {
            count = 2;
        }
 
    }
    return count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        switch (indexPath.section) {
            case 0:
            {
                
            }
            case 1:
            {
                
            }
        }
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            break;
        }
        case 1:
        {
            
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return CGSizeMake(kScreenWidth, DDRealValue(184));
        }
        case 1:
        {
            return CGSizeMake(kScreenWidth, 44);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            break;
        }
       case 1:
        {
            return CGSizeMake(100, 100);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat h = DDRealValue(184) - navigationHeight;
    
    if (y < 0) {
        self.navigationBar.hidden = YES;
        return;
    }
    
    self.navigationBar.hidden = NO;
    if (y <= h && y >= 0) {
        self.navigationBar.backgroundColor = [GLOBAL_COLOR colorWithAlphaComponent:(y / h)];
        return;
    } else {
        self.navigationBar.backgroundColor = GLOBAL_COLOR;
    }
}

#pragma mark - 增加假的导航条
- (void)addNavigationBar
{
    CHNavigationBar *navigationBar = [[CHNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navigationHeight)];
    self.navigationBar = navigationBar;
    [self.view addSubview:navigationBar];
}

#pragma mark - 初始化
- (void)initAttribute
{
    _count = 0;
}

#pragma mark - 导航栏右侧的点击事件
- (void)clickRightNavigationItemEvent
{
    CGFloat width = kScreenWidth / 3;
    NSArray *array = @[@"添加朋友", @"扫一扫", @"我的二维码"];
    weakSelf(wself);
    if (_count % 2 == 0) {
        _publishView = [CH_Publish_View setPublishViewFrame:CGRectMake(kScreenWidth - width - 8, 8, width, array.count * 55) andBackground:HexColor(0xffffff) andTitleArray:array andImageArray:nil andTitleColor:HexColor(0xffffff) andTitleFont:13 andTitleBackground:HexColor(0x000000)];
        _publishView.whenButtonClick = ^(NSInteger tag) {
            switch (tag) {
                case 0:
                {
                    CHAdd_FriendViewController *friendVC = [CHAdd_FriendViewController new];
                    [wself.navigationController pushViewController:friendVC animated:NO];
                }
                    break;
                case 1:
                {
                    CHScanCodeViewController *scan = [CHScanCodeViewController new];
                    //        CHNavigationViewController *navc = [[CHNavigationViewController alloc] initWithRootViewController:scan];
                    //        [wself presentViewController:navc animated:YES completion:nil];
                    [wself.navigationController pushViewController:scan animated:NO];
                }
                    break;
                case 2:
                    NSLog(@"我的二维码");
                    break;
                    
                default:
                    break;
            }
        };
        [self.view addSubview:_publishView];
    } else {
        [_publishView removeFromSuperview];
    }
    _count ++;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _count = 0;
    [_publishView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
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
