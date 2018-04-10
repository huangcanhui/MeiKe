//
//  CHOrganizationListView.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/10.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHOrganizationListView.h"
#import "CHManager.h"
#import "CHImageAndTitleButton.h"
#import "MJExtension.h"
#import "CHOrganListModel.h"
#import "UIButton+WebCache.h"

@interface CHOrganizationListView ()
/**
 * 机构列表数组
 */
@property (nonatomic, strong)NSArray *organArr;
@end

@implementation CHOrganizationListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self requestData:frame];
    }
    return self;
}

- (void)createUI:(CGRect)frame
{
    CGFloat buttonW = (frame.size.width - 64) / 4;
    if (self.organArr.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = @"暂时没有您的机构";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    } else {
        for (int i = 0; i < self.organArr.count; i++) {
            CHOrganListModel *model = self.organArr[i];
            CHImageAndTitleButton *button = [[CHImageAndTitleButton alloc] initWithFrame:CGRectMake(8 + (buttonW + 16) * i, 0, buttonW, frame.size.height - 5)];
            [button setTitle:model.simple_name forState:UIControlStateNormal];
            [button setTitleColor:HexColor(0x000000) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.numberOfLines = 0;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Origan_more"]];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(organizationListClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
}

- (void)organizationListClick:(CHImageAndTitleButton *)sender
{
    CHOrganListModel *model = self.organArr[sender.tag - 100];
    if (self.enterOrganizationList) {
        self.enterOrganizationList(model.id, model.simple_name);
    }
}

- (void)requestData:(CGRect)frame
{
    _organArr = [NSArray new];
    NSString *path = CHReadConfig(@"organization_JoinList_Url");
    NSDictionary *params = @{
                             @"page":@"1",
                             @"page_size":@"15",
                             };
    [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:params WithSuccessBlock:^(NSDictionary *responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"]) {
            CHOrganListModel *model = [CHOrganListModel mj_objectWithKeyValues:dict];
            [arrayM addObject:model];
        }
        if (arrayM.count < 3) { //用户机构数量小于3个，一页全部展示
            _organArr = [arrayM copy];
        } else {
            CHOrganListModel *model = [CHOrganListModel new];
            model.simple_name = @"更多";
            model.id = @0;
            model.logo = @"Origan_more";
            [arrayM replaceObjectAtIndex:3 withObject:model];
            _organArr = @[arrayM[0], arrayM[1], arrayM[2], arrayM[3]];
        }
         [self createUI:frame];
    } WithFailurBlock:^(NSError *error) {
        
    }];
}

@end
