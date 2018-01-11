//
//  CHPublishDetailViewController.h
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListModel.h"

@interface CHPublishDetailViewController : UIViewController

@property (nonatomic, copy)void (^getCommunityData)(FriendListModel *model, BOOL isPrivate);

@end
