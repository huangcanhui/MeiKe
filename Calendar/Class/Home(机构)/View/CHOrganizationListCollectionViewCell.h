//
//  CHOrganizationListCollectionViewCell.h
//  Calendar
//
//  Created by huangcanhui on 2018/4/10.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHOrganListModel.h"

@interface CHOrganizationListCollectionViewCell : UICollectionViewCell

/**
 * 数据源
 */
@property (nonatomic, strong)CHOrganListModel *model;
@end
