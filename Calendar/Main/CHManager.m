//
//  CHManager.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/9.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHManager.h"
#import "ProgressHUD.h"
#import "mobile.h"

@interface CHManager ()
@property (nonatomic, strong)User *user;
@end

@implementation CHManager

+ (instancetype)manager
{
    //    static CHManager *manager = nil;
    //    static dispatch_once_t pred;
    //    dispatch_once(&pred, ^{
    //        manager  = [[self alloc] initWithBaseURL:[NSURL URLWithString:configUrl]];
    //    });
    //    return manager;
    static CHManager *manager = nil;
    manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:configUrl]];
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer.timeoutInterval = 100;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _user = [User readUserDefaultWithKey:@"UserModel.user"];
        if (_user.access_token != nil) {
            [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", _user.access_token] forHTTPHeaderField:@"Authorization"];
        }
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        //        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO; //不验证证书域名
    }
    return self;
}

- (void)requestWithMethod:(HTTPMethod)method WithPath:(NSString *)path WithParams:(NSDictionary *)params WithSuccessBlock:(requestSuccessBlock)success WithFailurBlock:(requestFailureBlock)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", configUrl, path];
    switch (method) {
        case GET:
        {
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
                NSInteger statusCode = response.statusCode;
                if (statusCode == 401) { //鉴权失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"access_token_fail" object:nil];
                } else {
                    [self togetherDealWithErrorCodeError:error];
                }
            }];
        }
            break;
            
        case POST:
        {
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
                NSInteger statusCode = response.statusCode;
                if (statusCode == 401) { //鉴权失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"access_token_fail" object:nil];
                } else {
                     [self togetherDealWithErrorCodeError:error];
                }
               
                //                [ProgressHUD showError:dict[@"message"]];
//
////                NSString *path = [[NSBundle mainBundle] pathForResource:@"ERROECODE.plist" ofType:nil];
////                NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//                NSString *status = [NSString stringWithFormat:@"%ld", (long)statusCode];
//                NSLog(@"%@", operation);
//                [ProgressHUD showError:status];
            }];
        }
            break;
        case PATCH:
        {
            [self PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
                [self togetherDealWithErrorCodeError:error];
            }];
        }
            break;
        case DELETE:
        {
            [self DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self togetherDealWithErrorCodeError:error];
            }];
        }
            break;
        case PUT:
        {
            [self PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self togetherDealWithErrorCodeError:error];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)togetherDealWithErrorCodeError:(NSError *)error
{
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
//        NSInteger statusCode = response.statusCode;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"ERROECODE.plist" ofType:nil];
    //    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    //    NSString *status = [NSString stringWithFormat:@"%ld", (long)statusCode];
    
    NSData *data = [[error userInfo][@"com.alamofire.serialization.response.error.string"] dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        [SVProgressHUD showErrorWithStatus:dict[@"message"]];
        [ProgressHUD showError:dict[@"message"] Interaction:YES];
    }
}


- (void)uploadWithURLString:(NSString *)urlString withParams:(NSDictionary *)params withImageData:(NSData *)data withSuccessBlock:(requestSuccessBlock)success withFailurBlock:(requestFailureBlock)failure
{
    
}

@end
