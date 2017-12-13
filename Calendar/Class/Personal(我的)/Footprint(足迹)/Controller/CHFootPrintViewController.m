//
//  CHFootPrintViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFootPrintViewController.h"
#import "CHSilderView.h"
#import "CHTimeSliderView.h"

@interface CHFootPrintViewController ()<CHSliderViewDelgate>
/**
 * 时光轴
 */
@property (nonatomic, strong)CHTimeSliderView *slider;
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
//    self.slider = [[CHSilderView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, 20)];
//    self.slider.text = @"我的时光轴";
//    self.slider.isVertical = YES;
//    self.slider.thumbHidden = YES;
//    self.slider.thumbBack = NO;
//    self.slider.delegate = self;
//    [self.view addSubview:self.slider];
    self.slider = [[CHTimeSliderView alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 10, 25, kScreenHeight - navigationHeight - tabbarHeight - 20)];
    [self.slider setColorForBackView:[UIColor darkGrayColor] sliderColor:[UIColor orangeColor] textColor:[UIColor whiteColor] borderColor:[UIColor blackColor]];
    self.slider.minValue = 0;
    self.slider.minValue = 1;
    self.slider.text = @"长按滑动我的时光轴";
    [self.view addSubview:self.slider];
    
    
}

-(void)sliderValueChanging:(CHSilderView *)slider
{
    NSLog(@"%f", slider.value);
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
