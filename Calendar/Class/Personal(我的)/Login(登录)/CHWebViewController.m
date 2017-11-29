//
//  CHWebViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/28.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHWebViewController.h"

@interface CHWebViewController ()
/**
 * 嵌入的网页
 */
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation CHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = self.content;
    
    [self.view addSubview:self.webView];
}

#pragma mark - 懒加载
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webString]];
        [_webView loadRequest:request];
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
