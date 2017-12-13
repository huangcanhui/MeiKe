//
//  CHFriendCircleTableViewCell.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/12.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendCircleTableViewCell.h"

#import "CHFriendCellCommentView.h"
#import "CHFriendPhotoContainerView.h"
#import "UIView+SDAutoLayout.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; //根据具体的font而定

@interface CHFriendCircleTableViewCell ()
/**
 * 发布者的头像
 */
@property (nonatomic, strong)UIImageView *iconView;
/**
 * 发布者的昵称
 */
@property (nonatomic, strong)UILabel *nameLabel;
/**
 * 文章内容
 */
@property (nonatomic, strong)UILabel *contentLabel;
/**
 * 文章是否全部展开
 */
@property (nonatomic, assign)BOOL shouldOpenContentLabel;
/**
 * 全文按钮
 */
@property (nonatomic, strong)UIButton *moreButton;
/**
 * 评论按钮
 */
@property (nonatomic, strong)UIButton *operationButton;
/**
 * 评论视图
 */
@property (nonatomic, strong)CHFriendCellCommentView *commentView;
/**
 * 图片视图
 */
@property (nonatomic, strong)CHFriendPhotoContainerView *friendContainerView;
/**
 * 时间
 */
@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation CHFriendCircleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    self.shouldOpenContentLabel = NO; //默认不全部展开
    
    self.iconView = [UIImageView new];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor blueColor];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = self.contentLabel.font.lineHeight * 3;
    }
    
    self.moreButton = [UIButton new];
    [self.moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [self.moreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.operationButton = [UIButton new];
    [self.operationButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.operationButton.backgroundColor = [UIColor redColor];
    [self.operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentView = [CHFriendCellCommentView new];
    
    self.friendContainerView = [CHFriendPhotoContainerView new];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    
    NSArray *views = @[self.iconView, self.nameLabel, self.contentLabel, self.moreButton, self.friendContainerView, self.timeLabel, self.operationButton, self.commentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    //开启自动布局
    self.iconView.sd_layout.leftSpaceToView(contentView, margin).topSpaceToView(contentView, margin + 5).widthIs(40).heightIs(40);
    
    self.nameLabel.sd_layout.leftSpaceToView(self.iconView, margin).topEqualToView(self.iconView).heightIs(18);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.contentLabel.sd_layout.leftEqualToView(self.nameLabel).topSpaceToView(self.nameLabel, margin).rightSpaceToView(contentView, margin).autoHeightRatio(0);
    
    self.moreButton.sd_layout.leftEqualToView(self.contentLabel).topSpaceToView(self.contentLabel, 0).widthIs(30); //高度在setmodel里面设置
    
    self.friendContainerView.sd_layout.leftEqualToView(self.contentLabel); //已经在内部实现宽度和高度自适应，所以不需要在设置宽高，top值具体有无在setmodel方法中设置
    
    self.timeLabel.sd_layout.leftEqualToView(self.contentLabel).topSpaceToView(self.friendContainerView, margin).heightIs(15).autoHeightRatio(0);
    
    self.operationButton.sd_layout.rightSpaceToView(contentView, margin).centerYEqualToView(self.timeLabel).heightIs(25).widthIs(25);
    
    self.commentView.sd_layout.leftEqualToView(self.contentLabel).rightSpaceToView(self.contentView, margin).topSpaceToView(self.timeLabel, margin); //已经在内部实现高度自适应所以不需要在设置高度
}

#pragma mark - 传值
- (void)setObject:(FriendCircleObject *)object
{
    
}


#pragma mark - 全文的点击事件
- (void)moreButtonClicked
{
    if (self.moreButtonClickBlock) {
        self.moreButtonClickBlock(self.indexPath);
    }
}

#pragma mark - 评论的点击事件
- (void)operationButtonClicked
{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
