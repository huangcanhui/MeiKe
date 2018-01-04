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

#import "CHFriend_SearchView.h"
#import "ProgressHUD.h"
#import "CHContact.h"
#import "CH_Publish_View.h"
#import "MJExtension.h"
#import "CHPersonalData.h"
#import "CHManager.h"

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
@property (nonatomic, strong)NSMutableArray *charArrayM; //右侧的索引数据
@property (nonatomic, strong)NSArray *array; //添加朋友...
@property (nonatomic, strong)NSArray *friendArray; // 好友列表
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
        _publishView = [CH_Publish_View setPublishViewFrame:CGRectMake(kScreenWidth - width - 8, 8, width, array.count * 50) andBackground:HexColor(0xffffff) andTitleArray:array andImageArray:nil andTitleColor:HexColor(0xffffff) andTitleFont:13 andTitleBackground:HexColor(0x000000)];
        _publishView.whenButtonClick = ^(NSInteger tag) {
            switch (tag) {
                case 0:
                    NSLog(@"添加朋友");
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
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) { //判断用户是否授权
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) { //授权成功
                //获取联系人仓库
                NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
                //根据请求key，获取请求对象
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                //发送请求
                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    NSString *nameString = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
                    NSArray *phoneNumbers = contact.phoneNumbers;
                    for (CNLabeledValue *labelValue in phoneNumbers) {
                        CNPhoneNumber *number = labelValue.value;
                        NSLog(@"phone:%@", number.stringValue);
                    }
                    NSLog(@"%@", nameString);
                }];
            } else {
                [ProgressHUD showError:@"授权失败\n如果需要开启，请在设置-信格-通讯录中开启" Interaction:NO];
            }
        }];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)charArrayM
{
    if (!_charArrayM) {
        self.charArrayM = [NSMutableArray array];
        [self.charArrayM addObject:[NSString stringWithFormat:@"*"]];
        for (char c = 'A'; c <= 'Z'; c++) {
            [self.charArrayM addObject:[NSString stringWithFormat:@"%c", c]];
        }
        [self.charArrayM addObject:[NSString stringWithFormat:@"#"]];
    }
    return _charArrayM;
}

- (NSArray *)array
{
    if (!_array) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Friend_Company" ofType:@"plist"];
        NSArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        _array = [CHPersonalData mj_objectArrayWithKeyValuesArray:tempArray];
    }
    return _array;
}

- (NSArray *)friendArray
{
    if (!_friendArray) {
        NSString *path = CHReadConfig(@"friend_List_Url");
        [[CHManager manager] requestWithMethod:GET WithPath:path WithParams:nil WithSuccessBlock:^(NSDictionary *responseObject) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                
            }
        } WithFailurBlock:^(NSError *error) {
            
        }];
    }
    return _friendArray;
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
        _tableView.tableHeaderView = self.searchView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.array.count;
    } else {
        return self.friendArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.charArrayM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bundleID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bundleID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"friends_UserImage"];
    }
    if (indexPath.section == 0) {
        CHPersonalData *data = self.array[indexPath.row];
        cell.textLabel.text = data.title;
        cell.imageView.image = [UIImage imageNamed:data.icon];
    } else {
        cell.textLabel.text = @"哈哈";
    }
   
    
    return cell;
}

//右侧的索引数据
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.charArrayM;
}

//跳转到指定的组
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for (NSString *character in self.charArrayM) {
        if ([character isEqualToString:title]) {
            return count;
        }
        count++;
    }
    return 0;
}

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
        return self.charArrayM[section];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
