//
//  RCDDataBaseManager.m
//  Calendar
//
//  Created by huangcanhui on 2018/4/9.
//  Copyright © 2018年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "RCDDataBaseManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import <RongIMLib/RongIMLib.h>

@interface RCDDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation RCDDataBaseManager

static NSString *const UserTableName = @"USERTABLE";
static NSString *const FriendTableName = @"FRIENDSTABLE";

+ (RCDDataBaseManager *)shareInstance
{
    static RCDDataBaseManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance dbQueue];
    });
    return instance;
}

/**
 苹果审核时，要求打开itunes sharing功能的app在Document目录下不能放置用户处理不了的文件
 2.8.9之前的版本数据库保存在Document目录
 从2.8.9之前的版本升级的时候需要把数据库从Document目录移动到Library/Application Support目录
 */
- (void)moveDBFile
{
    NSString *const rongIMDemoDBString = @"YMStarsDB";
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,
                                                                 YES)[0] stringByAppendingPathComponent:@"YMStars"];
    NSArray<NSString *> *subPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    [subPaths enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj hasPrefix:rongIMDemoDBString]) {
            [self moveFile:obj fromPath:documentPath toPath:libraryPath];
        }
    }];
}

- (void)moveFile:(NSString *)fileName fromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:toPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    NSString *srcPath = [fromPath stringByAppendingPathComponent:fileName];
    NSString *dstPath = [toPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:nil];
}

- (FMDatabaseQueue *)dbQueue
{
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId == nil) {
        return nil;
    }
    if (!_dbQueue) {
        [self moveDBFile];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *const YMStars = @"YMStars";
        NSString *library = [[paths objectAtIndex:0] stringByAppendingPathComponent:YMStars];
        NSString *dbPath = [library stringByAppendingPathComponent:[NSString stringWithFormat:@"YMStarsDB%@", [RCIMClient sharedRCIMClient].currentUserInfo.userId]];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (_dbQueue) {
            [self createUserTableIfNeed];
        }
    }
    return _dbQueue;
}

//创建用户存储表
- (void)createUserTableIfNeed
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (![self isTableOk:UserTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY"
                                       @"KEY autoincrement, userid text,name text, "
                                       @"portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![self isTableOk:FriendTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE FRIENDSTABLE (id integer"
                                       @"PRIMARY KEY autoincrement, userid "
                                       @"text,name text, portraitUri text, status "
                                       @"text, updatedAt text, displayName text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_friendsId ON FRIENDSTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
    }];
}

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user
{
    NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql, user.userId, user.name, user.portraitUri];
    }];
}

//存储用户列表信息
- (void)insertUserListToDB:(NSMutableArray *)userList complete:(void (^)(BOOL))result
{
    if (userList == nil || [userList count] < 1)
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (RCUserInfo *user in userList) {
                NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
                if (user.portraitUri.length <= 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        user.portraitUri = @"LOGO";
                    });
                }
                [db executeUpdate:insertSql, user.userId, user.name, user.portraitUri];
            }
        }];
        result(YES);
    });
}

//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId
{
    __block RCUserInfo *model = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?", userId];
        while ([rs next]) {
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return model;
}

//从表中获取所有的用户信息
- (NSArray *)getAllUserInfo
{
    NSMutableArray *allUsers = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE"];
        while ([rs next]) {
            RCUserInfo *model;
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

//存储好友信息
- (void)insertFriendToDB:(RCUserInfo *)friendInfo
{
    NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql, friendInfo.userId, friendInfo.name, friendInfo.portraitUri];
    }];
}

- (void)insertFriendListToDB:(NSMutableArray *)FriendList complete:(void (^)(BOOL))result
{
    if (FriendList == nil || [FriendList count] < 1)
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (RCUserInfo *friendInfo in FriendList) {
                NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
                [db executeUpdate:insertSql, friendInfo.userId, friendInfo.name, friendInfo.portraitUri];
            }
        }];
        result(YES);
    });
}

//从表中获取所有的好友数据
- (NSArray *)getAllFriends
{
    NSMutableArray *allUsers = [NSMutableArray new];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM FRIENDSTABLE"];
        while ([rs next]) {
            RCUserInfo *model;
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

//从表中获取某个好友的信息
- (RCUserInfo *)getFriendInfo:(NSString *)friendId
{
    __block RCUserInfo *friendInfo;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM FRIENDSTABLE WHERE userid=?", friendId];
        while ([rs next]) {
            friendInfo = [RCUserInfo new];
            friendInfo.userId = [rs stringForColumn:@"userid"];
            friendInfo.name = [rs stringForColumn:@"name"];
            friendInfo.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return friendInfo;
}

//清楚某个好友数据
- (void)deleteFriendFromDB:(NSString *)userId
{
     NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM FRIENDSTABLE WHERE userid=%@", userId];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//清空好友数据
- (void)clearFriendsData
{
    NSString *deleteSql = @"DELETE FROM FRIENDSTABLE";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

- (void)closeDBForDisconnect
{
    self.dbQueue = nil;
}

- (BOOL)isTableOk:(NSString *)tableName withDB:(FMDatabase *)db
{
    BOOL isOK = NO;
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where "
                                       @"type ='table' and name = ?", tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count) {
            isOK = NO;
        } else {
            isOK = YES;
        }
    }
    [rs close];
    return isOK;
}

@end
