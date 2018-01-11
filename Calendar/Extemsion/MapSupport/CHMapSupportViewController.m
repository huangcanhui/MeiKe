//
//  CHMapSupportViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/10.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHMapSupportViewController.h"
//地图
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CHAlertViewManager.h"
#import "Address.h"

@interface CHMapSupportViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource,MAMapViewDelegate, AMapSearchDelegate>
/**
 * 定位器
 */
@property (nonatomic, strong)CLLocationManager *locationManager;
/**
 * UITableview
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *data;
/**
 * 地图搜索API
 */
@property (nonatomic, strong)AMapSearchAPI *searchAPI;
/**
 * MAMapView
 */
@property (nonatomic, strong)MAMapView *mapView;
/**
 * 选中的数据
 */
@property (nonatomic, assign)NSIndexPath *indexPath;

@end

@implementation CHMapSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"我的位置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightNavigationButton)];
    
    [self initAttribute];
    
    [self initMapView];
    
    [self.view addSubview:self.tableView];
    
    [self createCenterAnnotation];
}

#pragma mark - 视图的创建
- (void)initMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    AMapSearchAPI *searchAPI = [[AMapSearchAPI alloc] init];
    searchAPI.delegate = self;
    self.searchAPI = searchAPI;
}

#pragma mark MAMapView.delegate
//获取屏幕中心点
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    request.sortrule = 0; //按距离排序
    request.requireExtension = YES; //返回扩展信息
    [self.searchAPI AMapPOIAroundSearch:request];
}

#pragma mark - 创建一个屏幕中心的大头针
- (void)createCenterAnnotation
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 20, kScreenHeight / 2 - 40 - 25, 40, 40)];
    imageView.image = [UIImage imageNamed:@"Annotation_Red"];
    [self.view addSubview:imageView];
    
    //创建定位用户当前位置
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, self.tableView.CH_top - 40, 32, 32)];
    userImageView.image = [UIImage imageNamed:@"annotation_Self"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserAnnotation)];
    userImageView.userInteractionEnabled = YES;
    [userImageView addGestureRecognizer:tap];
    [self.view addSubview:userImageView];
}

#pragma mark 定位用户当前位置
- (void)clickUserAnnotation
{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}

#pragma mark AMapSearchAPI.delegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count > 0) { //当搜索结果大于0时
        NSMutableArray *arrayM = [NSMutableArray array];
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Address *address = [[Address alloc] init];
            address.address = [NSString stringWithFormat:@"%@%@%@", obj.city, obj.district, obj.address];
            address.name = obj.name;
            address.lat = [NSString stringWithFormat:@"%f", obj.location.latitude];
            address.lng = [NSString stringWithFormat:@"%f", obj.location.longitude];
            [arrayM addObject:address];
        }];
        self.data = [arrayM copy];
        [self.tableView reloadData];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2, kScreenWidth, kScreenHeight / 2 - statusHeight - 44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
         return self.data.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == self.indexPath.section) {
        if (indexPath.row == self.indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 1) {
        Address *address = self.data[indexPath.row];
        cell.textLabel.text = address.name;
        cell.detailTextLabel.text = address.address;
    } else {
        cell.textLabel.text = @"不显示位置";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    [self.tableView reloadData];
}

#pragma mark - 初始化数据
- (void)initAttribute
{
    self.data = [NSArray array];
    if ([CLLocationManager locationServicesEnabled] == YES) { //开启定位服务
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark CLLocationManager.delegate
//用户如果不允许定位，则调用该方法来进行提示
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        [CHAlertViewManager alertWithTitle:@"定位失败" message:@"寻易想获取您的位置\n\n方便为您提供更优质的服务" textFieldNumber:0 actionNumber:2 actionTitles:@[@"取消", @"设置"] textFieldHandler:^(UITextField *textField, NSUInteger index) {
            
        } actionHandler:^(UIAlertAction *action, NSUInteger index) {
            if (index == 0) { //取消
                
            } else {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
            }
        }];
    }
}

#pragma mark - 导航栏右按钮的点击事件
- (void)clickRightNavigationButton
{
    if (self.indexPath.section == 0) {
        if (self.whenAddressGet) {
            self.whenAddressGet(nil);
        }
    } else {
        Address *address = self.data[self.indexPath.row];
        if (self.whenAddressGet) {
            self.whenAddressGet(address);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
