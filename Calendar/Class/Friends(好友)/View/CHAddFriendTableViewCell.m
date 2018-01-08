//
//  CHAddFriendTableViewCell.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/4.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHAddFriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CHNetString.h"

@interface CHAddFriendTableViewCell ()
/**
 * 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
/**
 * 用户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**
 * 留言
 */
@property (weak, nonatomic) IBOutlet UILabel *memo;

@end

@implementation CHAddFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CHAddFriendModel *)model
{
    _model = model;
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:_model.sender.avatar]] placeholderImage:[UIImage imageNamed:@"userName"]];
    _nickName.text = _model.sender.nickname;
    _memo.text = _model.message;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
