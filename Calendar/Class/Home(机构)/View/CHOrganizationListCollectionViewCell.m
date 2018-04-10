//
//  CHOrganizationListCollectionViewCell.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/10.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHOrganizationListCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface CHOrganizationListCollectionViewCell ()
/**
 * 封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *cover;
/**
 * 机构名称
 */
@property (weak, nonatomic) IBOutlet UILabel *simple_name;
/**
 * 机构地址
 */
@property (weak, nonatomic) IBOutlet UILabel *address;
@end

@implementation CHOrganizationListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CHOrganListModel *)model
{
    _model = model;
    [_cover sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    _simple_name.text = model.simple_name;
    _address.text = [NSString stringWithFormat:@"地址:%@", model.address];
}

@end
