//
//  CHScanCodeViewController.m
//  YMStars
//
//  Created by HFY on 2017/8/3.
//  Copyright © 2017年 huangcanhui. All rights reserved.
//

#import "CHScanCodeViewController.h"
#import "IndexView.h"

@interface CHScanCodeViewController ()<IndexViewDelegate>

@end

@implementation CHScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫一扫";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initScanCodeView];
}

- (void)initScanCodeView
{
    IndexView *scancode = [[IndexView alloc] initWithFrame:self.view.bounds];
    scancode.delegate = self;
    [self.view addSubview:scancode];
}

- (void)ybsView:(IndexView *)view ScanResult:(NSString *)result
{
    [view stopScan];
    NSLog(@"%@", result);
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
