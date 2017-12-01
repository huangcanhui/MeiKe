//
//  CHFriend_SearchView.h
//  Calendar
//
//  Created by huangcanhui on 2017/12/1.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHFriend_SearchView;

typedef void (^friendSearchClick)(CHFriend_SearchView *view);

@interface CHFriend_SearchView : UIView

/**
 * 这个是为了模仿成一个UISearchBar
 */
+ (CHFriend_SearchView *)searchViewWithFrame:(CGRect)frame andBackGroundColor:(UIColor *)backColor andPlaceholder:(NSString *)placeholder;

@end
