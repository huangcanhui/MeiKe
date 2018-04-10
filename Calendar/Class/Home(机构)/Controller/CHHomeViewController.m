//
//  CHHomeViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/3/7.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHHomeViewController.h"

#import "CHHomeDetailViewController.h"
#import "CHOrganizationListCollectionViewCell.h"

#import "CHManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CHOrganListModel.h"

@interface CHHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/**
 * UICollectionView
 */
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
/**
 * 数据源
 */
@property (nonatomic, strong)NSMutableArray *dataSource;
/**
 * 页数
 */
@property (nonatomic, assign)int page;
@end

@implementation CHHomeViewController

static NSString *const cellBundleID = @"bundleID";
static CGFloat Margin = 8.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的机构列表";
    
    self.page = 1;
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.dataSource = [NSMutableArray new];
    
    [self setOriganizationTable];
    
    [self requestDataWithID:1];
}

#pragma mark - 创建机构列表
- (void)setOriganizationTable
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = HexColor(0xffffff);
    //添加刷新控件
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.dataSource removeAllObjects];
        [self requestDataWithID:self.page];
        [collectionView.mj_header endRefreshing];
    }];
    
    //添加加载控件
    collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self requestDataWithID:self.page];
        [collectionView.mj_footer endRefreshing];
    }];
    
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"CHOrganizationListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellBundleID];
    
    [self.view addSubview:collectionView];
}

#pragma mark UICollectionView.delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHOrganizationListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellBundleID forIndexPath:indexPath];
    CHOrganListModel *model = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell setModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHOrganListModel *model = self.dataSource[indexPath.row];
    CHHomeDetailViewController *detailVC = [CHHomeDetailViewController new];
    detailVC.origanizationID = model.id;
    detailVC.simple_name = model.simple_name;
    [self.navigationController pushViewController:detailVC animated:NO];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kScreenWidth - 4 * Margin) / 2;
        //设置单元格大小
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 56);
        //最小行间距
        _flowLayout.minimumLineSpacing = 8;
        //设置section的内边距
        _flowLayout.sectionInset = UIEdgeInsetsMake(Margin, Margin, Margin, Margin);
        //设置UICollectionView的滑动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

#pragma mark - 网络请求
- (void)requestDataWithID:(int)page
{
    NSString *path = CHReadConfig(@"organization_JoinList_Url");
    NSDictionary *params = @{
                             @"page":[NSString stringWithFormat:@"%d", self.page],
                             @"page_size":@"15",
                             @"include":@"type"
                             };
    [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            CHOrganListModel *model = [CHOrganListModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
    } WithFailurBlock:^(NSError *error) {
        
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
