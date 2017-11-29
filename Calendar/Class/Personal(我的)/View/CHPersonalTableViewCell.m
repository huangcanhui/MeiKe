//
//  CHPersonalTableViewCell.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/16.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHPersonalTableViewCell.h"

@interface CHPersonalTableViewCell ()
/**
 * 图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/**
 * 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation CHPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CHPersonalModel *)model
{
    _model = model;
    _icon.image = [UIImage imageNamed:_model.icon];
    _title.text = _model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
