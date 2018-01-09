//
//  CHFriend_HeaderView.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/8.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriend_HeaderView.h"

#import "UIImageView+WebCache.h"
#import "CHNetString.h"

@interface CHFriend_HeaderView ()
/**
 * 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
/**
 * 备注名
 */
@property (weak, nonatomic) IBOutlet UILabel *remark;
/**
 * 圈子号
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 * 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@end

@implementation CHFriend_HeaderView

+ (instancetype)headerView
{
    CHFriend_HeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"CHFriend_HeaderView" owner:nil options:nil] lastObject];
    //UI
    [view initView];
    
    return view;
}

- (void)initView
{
  
}

- (void)setObj:(FirendListObject *)obj
{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:obj.avatar]] placeholderImage:[UIImage imageNamed:@"Personal_BackHead"]];
    
    if ([obj.sex isEqualToString:@"男性"]) {
        _remark = [self stringWithImage:@"friend_sex_man" andRemarkName:obj.nickname];
    } else if ([obj.sex isEqualToString:@"女性"]) {
        _remark = [self stringWithImage:@"friend_sex_woman" andRemarkName:obj.nickname];
    } else {
        _remark.text = obj.nickname;
    }
    
    _name.text = [NSString stringWithFormat:@"圈子号:%@", obj.name];
    
    _nickName.text = [NSString stringWithFormat:@"昵称:%@", obj.remark];
}

#pragma mark - 富文本
- (UILabel *)stringWithImage:(NSString *)imageName andRemarkName:(NSString *)nickName
{
    //创建一个富文本
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    //图片名称
    attach.image = [UIImage imageNamed:imageName];
    //图片位置
    attach.bounds = CGRectMake(4, -4, 20, 20);
    
    NSString *subString = [NSString stringWithFormat:@"%@", nickName];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:subString];
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attach];
    
    [attri appendAttributedString:string];
    
    _remark.attributedText = attri;
    
    return _remark;
}

@end
