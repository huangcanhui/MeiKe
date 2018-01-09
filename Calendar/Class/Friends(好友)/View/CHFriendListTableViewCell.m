//
//  CHFriendListTableViewCell.m
//  Calendar
//
//  Created by huangcanhui on 2018/1/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendListTableViewCell.h"
#import "CHNetString.h"
#import "UIImageView+WebCache.h"

@interface CHFriendListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *name;
@end

@implementation CHFriendListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CHPersonalData *)model
{
    _avatar.image = [UIImage imageNamed:model.icon];
    _name.text = model.title;
}

- (void)setObject:(FirendListObject *)object
{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:object.avatar]] placeholderImage:[UIImage imageNamed:@"friends_UserImage"]];
    _name.text = object.nickname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
