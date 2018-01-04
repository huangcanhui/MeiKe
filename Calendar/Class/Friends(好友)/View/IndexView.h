//
//  IndexView.h
//  卡车妈妈
//
//  Created by fengcai0123 on 15/12/23.
//  Copyright © 2015年 张小东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexView;

@protocol IndexViewDelegate <NSObject>

- (void)ybsView:(IndexView *)view ScanResult:(NSString *)result;

@end

@interface IndexView : UIView

@property (nonatomic, assign)id<IndexViewDelegate>delegate;

@property (nonatomic, assign, readonly)CGRect scanViewFrame;

- (void)starrtScan;

- (void)stopScan;


@end
