//
//  CHFriend_SearchView.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/1.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriend_SearchView.h"

@implementation CHFriend_SearchView

+ (CHFriend_SearchView *)searchViewWithFrame:(CGRect)frame andBackGroundColor:(UIColor *)backColor andPlaceholder:(NSString *)placeholder
{
    CHFriend_SearchView *searchView = [[CHFriend_SearchView alloc] initWithFrame:frame];
    searchView.backgroundColor = backColor;
    
    //白框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
    view.backgroundColor = HexColor(0xffffff);
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    
    //搜索的图标
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, view.frame.size.height - 8, view.frame.size.height - 8)];
    imageView.image = [UIImage imageNamed:@"friends_search"];
    [view addSubview:imageView];
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.CH_right + 5, 2, view.frame.size.width, view.frame.size.height - 4)];
    label.text = placeholder;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    
    [searchView addSubview:view];
    
    return searchView;
    
}
@end
