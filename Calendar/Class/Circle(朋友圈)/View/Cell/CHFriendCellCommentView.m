//
//  CHFriendCellCommentView.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/12.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendCellCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "FriendCircleObject.h"
#import "MLEmojiLabel.h"

@interface CHFriendCellCommentView ()<MLEmojiLabelDelegate>
/**
 * 点赞数组
 */
@property (nonatomic, strong)NSArray *likeItemsArray;
/**
 * 评论数组
 */
@property (nonatomic, strong)NSArray *commentItemArray;
/**
 * 背景图片
 */
@property (nonatomic, strong)UIImageView *bgImageView;
/**
 * 点赞视图
 */
@property (nonatomic, strong)UILabel *likeLabel;
/**
 * 点赞下的下划线
 */
@property (nonatomic, strong)UIView *likeLabelBottomLine;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray *commentLabelsArray;
@end

@implementation CHFriendCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.bgImageView = [UIImageView new];
    UIImage *bgImage = [[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    self.bgImageView.image = bgImage;
    [self addSubview:self.bgImageView];
    
    self.likeLabel = [UILabel new];
    self.likeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.likeLabel];
    
    self.likeLabelBottomLine = [UIView new];
    self.likeLabelBottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.likeLabelBottomLine];
    
    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"circle_like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    for (int i = 0; i < likeItemsArray.count; i++) {
        LikerObject *obj = likeItemsArray[i];
        if (i > 0) {
            [attributeText appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
        }
        [attributeText appendAttributedString:[self generateAttributedStringWithLikeItemModel:obj]];
    }
    _likeLabel.attributedText = [attributeText copy];
}

- (void)setCommentItemArray:(NSArray *)commentItemArray
{
    _commentItemArray = commentItemArray;
    
    long originalLabelCount = _commentItemArray.count;
    long needsToAddCount = commentItemArray.count > originalLabelCount ? (commentItemArray.count - originalLabelCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLEmojiLabel *label = [MLEmojiLabel new];
        UIColor *highLightColor = [UIColor blueColor];
//        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.linkAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        
        [self.commentLabelsArray addObject:label];
    }
    for (int i = 0; i < commentItemArray.count; i++) {
        commentObject *obj = commentItemArray[i];
        MLEmojiLabel *label = _commentItemArray[i];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:obj];
    }
}

- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray array];
    }
    return _commentLabelsArray;
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(commentObject *)model
{
    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@":%@", model.comment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.firstUserID} range:[text rangeOfString:model.firstUserName]];
    if (model.secondUserName) {
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName :model.secondUserName} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(LikerObject *)model
{
    NSString *text = model.liker;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName:highLightColor, NSLinkAttributeName:model.liker} range:[text rangeOfString:model.liker]];
    return attString;
}

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemArray = commentItemsArray;
    
    [self.likeLabel sd_clearAutoLayoutSettings];
    self.likeLabel.frame = CGRectZero;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
            [label sd_clearAutoLayoutSettings];
            label.frame = CGRectZero;
        }];
    }
    
    CGFloat margin = 5;
    if (likeItemsArray.count) {
        self.likeLabel.sd_layout.leftSpaceToView(self, margin).rightSpaceToView(self, 0).topSpaceToView(self, 2 * margin).autoHeightRatio(0);
        self.likeLabel.isAttributedContent = YES;
    }
    
    UIView *lastTopView = self.likeLabel;
    for (int i = 0; i < self.commentItemArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        CGFloat topMargin = i == 0 ? 10 : 5;
        label.sd_layout.leftSpaceToView(self, 8).rightSpaceToView(self, 5).topSpaceToView(lastTopView, topMargin).autoHeightRatio(0);
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

#pragma mark - MLLinkLabelDelegate
//- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
//{
//    NSLog(@"%@", link.linkValue);
//}
@end
