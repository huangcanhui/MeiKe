//
//  CHFriend_SearchViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/12/1.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriend_SearchViewController.h"

@interface CHFriend_SearchViewController ()<UISearchBarDelegate>
/**
 * UISearchBar
 */
@property (nonatomic, strong)UISearchBar *searchBar;
@end

@implementation CHFriend_SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.titleView = self.searchBar;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        
        _searchBar.placeholder = @"请输入手机号或者用户名进行查找";
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        //将英文的cancle转变成中文“取消”
        for (id cancleBtn in [_searchBar.subviews[0]subviews]) {
            if ([cancleBtn isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)cancleBtn;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    searchBar.text = @"取消";
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"搜索");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
