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
#import "CHNetString.h"
#import "UIImageView+WebCache.h"
#import "CHFriendOperationMenu.h"

#import "CHTime.h"
#import "CHSepreatorString.h"

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
/**
 * 评论和点赞的按钮视图
 */
@property (nonatomic, strong)CHFriendOperationMenu *operationMenu;

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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)setup
{
    weakSelf(wself);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:@"CHFriendOperationMenu" object:nil];
    
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
    [self.operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [self.operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentView = [CHFriendCellCommentView new];
    
    self.friendContainerView = [CHFriendPhotoContainerView new];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    
    _operationMenu = [CHFriendOperationMenu new];
    [_operationMenu setLikeButtonClickedOPeration:^{
        if ([wself.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [wself.delegate didClickLikeButtonInCell:wself];
        }
    }];
    
    [_operationMenu setCommentButtonClickOperation:^{
        if ([wself.delegate respondsToSelector:@selector(didClickCommentButtonInCell:)]) {
            [wself.delegate didClickCommentButtonInCell:wself];
        }
    }];
    
    NSArray *views = @[self.iconView, self.nameLabel, self.contentLabel, self.moreButton, self.friendContainerView, self.timeLabel, self.operationButton, self.operationMenu, self.commentView];
    
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
    
    self.timeLabel.sd_layout.leftEqualToView(self.contentLabel).topSpaceToView(self.friendContainerView, margin).heightIs(15).widthIs(100);
    
    self.operationButton.sd_layout.rightSpaceToView(contentView, margin).centerYEqualToView(self.timeLabel).heightIs(25).widthIs(25);
    
    self.commentView.sd_layout.leftEqualToView(self.contentLabel).rightSpaceToView(self.contentView, margin).topSpaceToView(self.timeLabel, margin); //已经在内部实现高度自适应所以不需要在设置高度
    
    self.operationMenu.sd_layout.rightSpaceToView(_operationButton, 0).heightIs(36).centerYEqualToView(_operationButton).widthIs(0);
}

#pragma mark - 传值
- (void)setObject:(FriendCircleObject *)object
{
    _object = object;
    _commentView.frame = CGRectZero;
    [_commentView setupWithLikeItemsArray:object.liker commentItemsArray:object.comment];
    
    _shouldOpenContentLabel = NO;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[CHNetString isValueInNetAddress:object.owner.avatar]] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    _nameLabel.text = object.owner.nickname;
    //防止单行文本label在重用时宽度计算不准的问题
    [_nameLabel sizeToFit];
    _contentLabel.text = object.content;
    
    _friendContainerView.picPathStringArray = object.photos;
    
    if (object.shouldShowMoreButton) { //如果文字超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        
        if (object.isOpening) { //如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (object.photos.count) {
        picContainerTopMargin = 10;
    }
    
    _friendContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    UIView *bottomView;
    
    if (!object.comment.count && !object.liker.count) {
        _commentView.fixedWidth = @0; //如果没有评论或者点赞，设置commentView的固定宽度为0（设置了fixedWidth的控件将不再在自动布局过程中调整宽度）
        _commentView.fixedHeight = @0; //如果没有评论或者点赞，设置commentView的固定宽度为0（设置了fixedHeight的控件将不再在自动布局过程中调整宽度
        bottomView = _timeLabel;
    } else {
        _commentView.fixedHeight = nil; //取消固定宽度约束
        _commentView.fixedWidth = nil; //取消固定高度的约束
        _commentView.sd_layout.topSpaceToView(_timeLabel, 10);
        bottomView = _commentView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    //判断时间
    NSArray *currentArray = [CHSepreatorString stringToSepreator:[CHTime getTimeWithDateFormat] withChactor:@" "]; //获取系统的当前时间
    NSArray *oldArray = [CHSepreatorString stringToSepreator:object.created_at withChactor:@" "]; //获取说说发布的时间
    if ([currentArray[0] isEqualToString:oldArray[0]]) { //当天的说说
        NSArray *array = [CHSepreatorString stringToSepreator:oldArray[1] withChactor:@":"];
        _timeLabel.text = [NSString stringWithFormat:@"%@:%@", array[0], array[1]];
    } else { //隔天的说说
        NSArray *dateArray = [CHSepreatorString stringToSepreator:oldArray[0] withChactor:@"-"];
        NSArray *array = [CHSepreatorString stringToSepreator:oldArray[1] withChactor:@":"];
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@ %@:%@", dateArray[1], dateArray[2], array[0], array[1]];
    }
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
    [self postOperationButtonClickNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)postOperationButtonClickNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHFriendOperationMenu" object:_operationButton];
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
