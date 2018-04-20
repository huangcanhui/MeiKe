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

@interface CHFriendCellCommentView ()
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
    
    long originalLabelCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemArray.count > originalLabelCount ? (commentItemArray.count - originalLabelCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = i;
        [self addSubview:label];
        
        [self.commentLabelsArray addObject:label];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelTapped:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
    }
    for (int i = 0; i < commentItemArray.count; i++) {
        commentObject *obj = commentItemArray[i];
        UILabel *label = self.commentLabelsArray[i];
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
    [attString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], NSLinkAttributeName : model.firstUserName} range:[text rangeOfString:model.firstUserName]];
    if (model.secondUserName) {
        [attString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], NSLinkAttributeName :model.secondUserName} range:[text rangeOfString:model.secondUserName]];
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
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
            [label sd_clearAutoLayoutSettings];
//            label.frame = CGRectZero;
            label.hidden = YES; //重用时先隐藏，然后根据评论个数显示label
        }];
    }
    
    CGFloat margin = 5;
    UIView *lastTopView = nil;
    if (likeItemsArray.count) {
        self.likeLabel.sd_layout.leftSpaceToView(self, margin).rightSpaceToView(self, 0).topSpaceToView(self, 2 * margin).autoHeightRatio(0);
        self.likeLabel.isAttributedContent = YES;
        lastTopView = self.likeLabel;
    } else {
        self.likeLabel.sd_resetLayout.heightIs(0);
    }
    
    if (self.commentItemArray.count && self.likeItemsArray.count) {
        self.likeLabelBottomLine.sd_resetLayout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(1).topSpaceToView(lastTopView, 3);
        lastTopView = _likeLabelBottomLine;
    } else {
        _likeLabelBottomLine.sd_resetLayout.heightIs(0);
    }
    
    for (int i = 0; i < self.commentItemArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        CGFloat topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 5;
        label.sd_layout.leftSpaceToView(self, 8).rightSpaceToView(self, 5).topSpaceToView(lastTopView, topMargin).autoHeightRatio(0);
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)commentLabelTapped:(UITapGestureRecognizer *)tap
{
    if (self.didClickCommentLabelBlock) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [tap.view.superview convertRect:tap.view.frame toView:window];
        commentObject *obj = self.commentItemArray[tap.view.tag];
        self.didClickCommentLabelBlock(obj.firstUserID, rect, obj.firstUserName);
    }
}

#pragma mark - MLLinkLabelDelegate
//- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
//{
//    NSLog(@"%@", link.linkValue);
//}
@end
