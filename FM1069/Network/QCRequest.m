    //
//  QCRequest.m
//  QunChangMob
//
//  Created by qiangli on 15/5/19.
//  Copyright (c) 2015年 dooban. All rights reserved.
//

#import "QCRequest.h"


@interface QCRequest ()

@property (strong, nonatomic) AFFinishedBlock finishedBlock;

@end

@implementation QCRequest

+ (instancetype)request
{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)baseUrl
{
    return BASE_URL;
}

- (NSString *)requestFullUrl
{
    NSString *fullUrl = nil;
    NSString *requestPath = [self requestPath];
    if ([requestPath hasPrefix:@"/"]) {
        fullUrl = [[self baseUrl] stringByAppendingString:requestPath];
    }else {
        fullUrl = [[self baseUrl] stringByAppendingFormat:@"/%@", requestPath];
    }
    return fullUrl;
}

- (NSString *)requestPath
{
    return nil;
}

- (NSDictionary *)parametes
{
    return nil;
}

- (id)parsingData:(id)data
{
    return nil;
}

- (void)reRequest
{
    [self startPostRequestWithFinishedBlock:self.finishedBlock];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startGetRequestWithFinishedBlock:(AFFinishedBlock)finishedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    self.finishedBlock = finishedBlock;
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }else {
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [manager.requestSerializer setValue:@"mob-form" forKey:@"x-form-id"];
    self.operation =[manager GET:[self requestFullUrl] parameters:[self parametes] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self successCallBackForOperation:operation responseObject:responseObject finishedBlock:finishedBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedCallBackForOperation:operation error:error finishedBlock:finishedBlock];
    }];
}

- (void)startPostRequestWithFinishedBlock:(AFFinishedBlock)finishedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    self.finishedBlock = finishedBlock;
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }else {
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [manager.requestSerializer setValue:@"mob-form" forHTTPHeaderField:@"x-form-id"];
    NSLog(@"path %@", [self requestPath]);
    NSLog(@"parametes%@", [self parametes]);
    self.operation = [manager POST:[self requestFullUrl] parameters:[self parametes] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GGFRequest Success: %@", responseObject);
        
        [self successCallBackForOperation:operation responseObject:responseObject finishedBlock:finishedBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseObject) {
            [self successCallBackForOperation:operation responseObject:operation.responseObject finishedBlock:finishedBlock];
        }else {
            [self failedCallBackForOperation:operation error:error finishedBlock:finishedBlock];
        }
    }];
}

- (void)successCallBackForOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObj finishedBlock:(AFFinishedBlock)finishedBlock;
{
    QCResponseEntity *entity = [[QCResponseEntity alloc] init];
    NSString *code = [responseObj valueForKey:@"code"];
    if ([code isEqualToString:@"ACK"]) {
        entity.success = YES;
        id sourceData = [responseObj valueForKey:@"data"];
        if (sourceData == [NSNull null]) {
            entity.data = nil;
        }else {
            id data = [self parsingData:[responseObj valueForKey:@"data"]];
            if (data) {
                entity.data = data;
            }else {
                entity.data = [responseObj valueForKey:@"data"];
            }
        }
        entity.msg = [responseObj valueForKey:@"message"];
    }else if ([code isEqualToString:@"SESSION_TIME_OUT"]){
        
//        [[NSNotificationCenter  defaultCenter] postNotificationName:NotiLoginTimeOut object:nil];
//        if ([QCUserManager canAutoLogin]) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reRequest) name:NotiLoginSuccessed object:nil];
//            [QCUserManager autoLogIn];
//        }
    
    }else {
        entity.success = NO;
        entity.msg = [responseObj valueForKey:@"message"];
    }
    finishedBlock(operation, entity);
}

- (void)failedCallBackForOperation:(AFHTTPRequestOperation *)operation error:(NSError *)err finishedBlock:(AFFinishedBlock)finishedBlock
{
    NSLog(@"GGFRequest Failure: %@", operation.responseString);
    
    if (operation.responseObject) {
        NSString *code = [operation.responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"SESSION_TIME_OUT"]){
            [[NSNotificationCenter  defaultCenter] postNotificationName:NotiLoginTimeOut object:nil];
            return;
        }
    }
    
    QCResponseEntity *entity = [[QCResponseEntity alloc] init];
    entity.success = NO;
    if (operation.responseString == nil) {
        entity.msg = @"网络访问失败";
    }else {
        entity.msg = @"返回数据解析失败";
    }
    finishedBlock(operation, entity);
}

@end
