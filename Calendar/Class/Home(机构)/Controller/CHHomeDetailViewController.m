//
//  CHHomeDetailViewController.m
//  Calendar
//
//  Created by huangcanhui on 2018/3/7.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHHomeDetailViewController.h"

#import "OriganizationModel.h"
#import "MJExtension.h"
#import "UILabel+CH.h"

static NSString *message = @"坚实的尽快发货数据库电话费坚实的房间卡华师大尽快发货就是看到回复就卡死的海景房哈就是肯定会发多少弗拉华盛顿法律环境维护经费收到回复举案说法按时交付啊可是加我回房间爱我合肥假设福建安徽福建安徽复健科阿黄金时代回复就我和交付货物已一晒与对方于死地发is地方哈数据库电话费";
@interface CHHomeDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *array;
@end

@implementation CHHomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的机构明细";
    
    if (self.isStick == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"置顶" style:UIBarButtonItemStyleDone target:self action:@selector(setOriganStick)];
    }
    
    [self setTableView];
    
    [self initBottomButton];
}

#pragma mark -置顶按钮的点击事件
- (void)setOriganStick
{
    NSLog(@"点击了置顶按钮");
}

- (void)setTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        OriganizationModel *model = self.array[section - 1];
        return model.detail.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [UILabel getHeightByWidth:kScreenWidth - 16 title:message font:[UIFont systemFontOfSize:17]];
    } else {
        return 35;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    if (section == 0) {
        label.text = @"小区公告";
    } else {
        label.text = @"本月费用明细";
    }
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detail"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = message;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0; //自动换行
    } else {
        OriganizationModel *model = _array[indexPath.section - 1];
        DetailObject *obj = model.detail[indexPath.row];
        NSString *useString = @"";
        NSString *priceString = @"";
        if (![obj.use isEqualToString:@""]) {
            useString = [NSString stringWithFormat:@"%@*", obj.use];
        }
        if (![obj.price isEqualToString:@""]) {
            priceString = [NSString stringWithFormat:@"%@=", obj.price];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@%@%@", obj.title, useString, priceString, obj.cost];
        cell.detailTextLabel.text = obj.memo;
    }
    return cell;
}

#pragma mark - 懒加载
- (NSArray *)array
{
    if (!_array) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CHOrigationPlist" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _array = [OriganizationModel mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _array;
}

#pragma mark - 添加求助按钮以及缴费按钮
- (void)initBottomButton
{
    NSArray *buttonArr = @[@"求助", @"缴费"];
    NSArray *buttonCol = @[[UIColor redColor], [UIColor blueColor]];
    NSLog(@"高度:%d", tabbarHeight);
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 * i, kScreenHeight - tabbarHeight - 19, kScreenWidth / 2, 49)];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        [button setTitleColor:HexColor(0xffffff) forState:UIControlStateNormal];
        button.backgroundColor = buttonCol[i];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(clickBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)clickBottomButton:(UIButton *)button
{
    NSLog(@"%ld", (long)button.tag);
}
@end
