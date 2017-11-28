//
//  CHCustomServiceViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHCustomServiceViewController.h"

@interface CHCustomServiceViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *array;
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * UIWebView
 */
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation CHCustomServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.title = @"客服";
    
    [self initTableView];
}

#pragma mark - UI
- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView = tableView;
    
    tableView.showsVerticalScrollIndicator = YES;
    tableView.showsHorizontalScrollIndicator = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    UIImage *image = [UIImage imageNamed:@"home_kefu_header"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.CH_height = DDRealValueBy6s(image.size.height);
    tableView.tableHeaderView = imageView;
    
    tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark UITableView.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"kefu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.array[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) { //微信客服
        cell.imageView.image = [UIImage imageNamed:@"home_kefu_weixin"];
    }
    
    if (indexPath.section == 1) { //电话客服
        cell.imageView.image = [UIImage imageNamed:@"home_kefu_phone"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.array[indexPath.section] isEqualToString:@"微信客服"]){
        NSString *weixin = @"寻易无线";
        [UIPasteboard generalPasteboard].string = weixin;
        [self alertWithTitle:@"提示" message:@"已复制微信公众号，打开 微信-通讯录-粘贴\"寻易无线\"公众号-关注" cancelTitle:@"取消" otherTitles:@"去关注" block:^{
            //跳转到微信页面
            [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
        }];
        
        return ;
    }
    
    if ([self.array[indexPath.section] isEqualToString:@"电话客服"]) {
        NSString *tel = [NSString stringWithFormat:@"tel:%@", companyPhone];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tel]]];
        //        [self alertWithTitle:@"提示" message:companyPhone cancelTitle:@"取消" otherTitles:@"拨打" block:^{
        //
        //        }];
        return ;
    }
}

#pragma mark - 懒加载
- (NSArray *)array
{
    if (!_array) {
        _array = @[@"微信客服", @"电话客服"];
    }
    return _array;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        [self.view addSubview:_webView];
    }
    return _webView;
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
