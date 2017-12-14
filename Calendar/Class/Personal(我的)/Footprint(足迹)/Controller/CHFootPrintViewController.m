//
//  CHFootPrintViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFootPrintViewController.h"
#import "CHTimeSliderView.h"
#import "CHTime.h"
#import "CHTimeShowView.h"

@interface CHFootPrintViewController ()
/**
 * 时光轴
 */
@property (nonatomic, strong)CHTimeSliderView *slider;
/**
 * 时间展示
 */
@property (nonatomic, strong)CHTimeShowView *timeView;

@end

@implementation CHFootPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"我的时光轴";
    
    [self initSliderView];
    
}

#pragma mark - 创建时间轴
- (void)initSliderView
{
    self.slider = [[CHTimeSliderView alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 10, 25, kScreenHeight - navigationHeight - tabbarHeight - 20)];
    [self.slider setColorForBackView:[UIColor darkGrayColor] sliderColor:[UIColor orangeColor] textColor:[UIColor whiteColor] borderColor:[UIColor blackColor]];
    self.slider.minValue = [@"1293267537" floatValue];
    self.slider.maxValue = [[CHTime getNowTimeTimestamp2] floatValue];
    self.slider.text = @"长按滑动我的时光轴";
    weakSelf(wself);
    self.slider.sliderValueChange = ^(NSString *value) {
        [wself.view addSubview:wself.timeView];
        wself.timeView.text = [CHTime getDateWithSecond:value];
    };
    self.slider.gesRecognizerEnd = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.timeView removeFromSuperview];
        });
    };
    [self.view addSubview:self.slider];
}

#pragma mark - 懒加载
- (CHTimeShowView *)timeView
{
    if (!_timeView) {
        _timeView = [[CHTimeShowView alloc] initWithFrame:CGRectMake(kScreenWidth / 4, kScreenHeight / 4, kScreenWidth / 2, kScreenWidth / 2)];
    }
    return _timeView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"滑动结束了");
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
