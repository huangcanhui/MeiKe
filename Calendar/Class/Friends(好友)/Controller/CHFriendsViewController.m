//
//  CHFriendsViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/7.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHFriendsViewController.h"

#import "CHFriend_SearchViewController.h"
#import "CHNavigationViewController.h"
#import "CHScanCodeViewController.h"
#import "CHAdd_FriendViewController.h"
#import "CHAdd_CommunityViewController.h"
#import "CHFriend_DetailViewController.h"
#import "CHFriendListTableViewCell.h"

#import "CHFriend_SearchView.h"
#import "ProgressHUD.h"
#import "CHContact.h"
#import "CH_Publish_View.h"
#import "MJExtension.h"
#import "CHPersonalData.h"
#import "CHManager.h"
#import "FirendListObject.h"
#import "FriendListGroup.h"
#import "UIImageView+WebCache.h"
#import "CHNetString.h"
#import "UserModel.h"
#import "UIViewController+CH.h"

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/ABRecord.h>

static NSString *bundleID = @"FRIENDS";
@interface CHFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>
/**
 * UITableView
 */
@property (nonatomic, strong)UITableView *tableView;
/**
 * 数据源
 */
@property (nonatomic, strong)NSArray *array; //添加朋友...
@property (nonatomic, strong)NSArray <FriendListGroup *> *friends;
/**
 * 搜索框
 */
@property (nonatomic, strong)CHFriend_SearchView *searchView;
/**
 * 导航栏右上角视图
 */
@property (nonatomic, strong)CH_Publish_View *publishView;
/**
 * 计数器
 */
@property (nonatomic, assign)int count;
@end

@implementation CHFriendsViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (![UserModel onLine]) {
        [self showLogin];
    } else {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexColor(0xffffff);
    
    self.navigationItem.title = @"好友";
    
    [self initAttribute];
    
    [self.view addSubview:self.tableView];
    
    _count = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNavigationView)];
}

#pragma mark - 导航栏的添加事件
- (void)addNavigationView
{
    CGFloat width = kScreenWidth / 3;
    NSArray *array = @[@"添加朋友", @"扫一扫", @"我的二维码"];
     weakSelf(wself);
    if (_count % 2 == 0) {
        _publishView = [CH_Publish_View setPublishViewFrame:CGRectMake(kScreenWidth - width - 8, 8, width, array.count * 55) andBackground:HexColor(0xffffff) andTitleArray:array andImageArray:nil andTitleColor:HexColor(0xffffff) andTitleFont:13 andTitleBackground:HexColor(0x000000)];
        _publishView.whenButtonClick = ^(NSInteger tag) {
            switch (tag) {
                case 0:
                {
                    CHAdd_FriendViewController *friendVC = [CHAdd_FriendViewController new];
                    [wself.navigationController pushViewController:friendVC animated:NO];
                }
                    break;
                case 1:
                {
                    CHScanCodeViewController *scan = [CHScanCodeViewController new];
                    //        CHNavigationViewController *navc = [[CHNavigationViewController alloc] initWithRootViewController:scan];
                    //        [wself presentViewController:navc animated:YES completion:nil];
                     [wself.navigationController pushViewController:scan animated:NO];
                }
                    break;
                case 2:
                    NSLog(@"我的二维码");
                    break;
                    
                default:
                    break;
            }
        };
        [self.view addSubview:_publishView];
    } else {
        [_publishView removeFromSuperview];
    }
    _count ++;
}

#pragma mark - 用户授权
- (void)initAttribute
{
//    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) { //判断用户是否授权
//        CNContactStore *store = [[CNContactStore alloc] init];
//        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) { //授权成功
//                //获取联系人仓库
//                NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
//                //根据请求key，获取请求对象
//                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
//                //发送请求
//                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//                    NSString *nameString = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
//                    NSArray *phoneNumbers = contact.phoneNumbers;
//                    for (CNLabeledValue *labelValue in phoneNumbers) {
//                        CNPhoneNumber *number = labelValue.value;
//                        NSLog(@"phone:%@", number.stringValue);
//                    }
//                    NSLog(@"%@", nameString);
//                }];
//            } else {
//                [ProgressHUD showError:@"授权失败\n如果需要开启，请在设置-信格-通讯录中开启" Interaction:NO];
//            }
//        }];
//    }
    
    NSString *path = CHReadConfig(@"friend_List_Url");
    [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
        [self sortByFirstChar:responseObject[@"data"]];
        [self.tableView reloadData];
    } WithFailurBlock:^(NSError *error) {

    }];
}

#pragma mark - 懒加载
- (NSArray *)array
{
    if (!_array) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Friend_Company" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _array = [CHPersonalData mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _array;
}

#pragma mark - 本地分类成组
- (void)sortByFirstChar:(NSArray *)array
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (int i = 0; i < array.count; i++) {
        FirendListObject *obj = [FirendListObject mj_objectWithKeyValues:array[i]];
        if (!obj.first_letter) {
            obj.first_letter = @"#";
        }
        NSMutableArray *arrayM = dictM[obj.first_letter];
        if (!arrayM) {
            arrayM = [NSMutableArray array];
            dictM[obj.first_letter] = arrayM;
        }
        [arrayM addObject:obj];
    }
    NSMutableArray *groups = [NSMutableArray array];
    for (int i = 0; i < dictM.allKeys.count; i++) {
        NSString *firstChar = dictM.allKeys[i];
        FriendListGroup *group = [FriendListGroup new];
        group.title = firstChar;
        group.list = dictM[firstChar];
        [groups addObject:group];
    }
    self.friends = [self sortArray:groups];
}

#pragma mark - 重新排序
- (NSArray *)sortArray:(NSArray *)data
{
    return [data sortedArrayUsingComparator:^NSComparisonResult(FriendListGroup *obj1, FriendListGroup *obj2) {
        return [obj1.title compare:obj2.title options:NSCaseInsensitiveSearch]; //不区分大小写
    }];
}

- (CHFriend_SearchView *)searchView
{
    if (!_searchView) {
        _searchView = [CHFriend_SearchView searchViewWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 45) andBackGroundColor:[UIColor grayColor] andPlaceholder:@"搜索"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewClick)];
        _searchView.userInteractionEnabled = YES;
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}

- (void)searchViewClick
{
    CHFriend_SearchViewController *friendVC = [CHFriend_SearchViewController new];
    CHNavigationViewController *naVC = [[CHNavigationViewController alloc] initWithRootViewController:friendVC];
    [self presentViewController:naVC animated:NO completion:nil];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, navigationHeight, 0);
        _tableView.backgroundColor = HexColor(0xffffff);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:@"CHFriendListTableViewCell" bundle:nil] forCellReuseIdentifier:bundleID];
//        _tableView.tableHeaderView = self.searchView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.array.count;
    } else {
        FriendListGroup *group = self.friends[section - 1];
        return group.list.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.friends.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHFriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bundleID];
    if (!cell) {
        cell = [[CHFriendListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bundleID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        CHPersonalData *data = self.array[indexPath.row];
        cell.model = data;
    } else {
        FriendListGroup *group = self.friends[indexPath.section - 1];
        FirendListObject *obj = group.list[indexPath.row];
        cell.object = obj;
    }
    return cell;
}

//右侧的索引数据
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.friends valueForKeyPath:@"title"];
}

////跳转到指定的组
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    NSInteger count = 0;
//    for (NSString *character in self.friends) {
//        if ([character isEqualToString:title]) {
//            return count;
//        }
//        count++;
//    }
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil ;
    } else {
        FriendListGroup *group = self.friends[section - 1];
        return group.title;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: //新朋友
            {
                CHAdd_FriendViewController *friendVC = [CHAdd_FriendViewController new];
                [self.navigationController pushViewController:friendVC animated:NO];
            }
                break;
            case 1: //添加圈子
            {
                CHAdd_CommunityViewController *communityVC = [CHAdd_CommunityViewController new];
                [self.navigationController pushViewController:communityVC animated:NO];
            }
                break;
            case 2://会员商家
                
                break;
                
                
            default:
                break;
        }
    } else {
        FriendListGroup *group = self.friends[indexPath.section - 1];
        FirendListObject *object = group.list[indexPath.row];
        CHFriend_DetailViewController *detailVC = [CHFriend_DetailViewController new];
        detailVC.object = object;
        detailVC.whenViewDisAppear = ^{
            [self initAttribute];
        };
        [self.navigationController pushViewController:detailVC animated:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _count = 0;
    [_publishView removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _count = 0;
    [_publishView removeFromSuperview];
}

@end
