//
//  QCRequest.h
//  QunChangMob
//
//  Created by qiangli on 15/5/19.
//  Copyright (c) 2015年 dooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCResponseEntity.h"
#import "AFNetworking.h"

typedef void (^AFFinishedBlock)(AFHTTPRequestOperation *operation, QCResponseEntity *responseObject);

@interface QCRequest : NSObject

@property (nonatomic, strong) NSString *progressMsg;
@property (nonatomic, strong) NSString *successMsg;
@property (nonatomic, strong) NSString *failedMsg;

@property (nonatomic, assign) BOOL *showIndicator;

@property (weak, nonatomic) AFHTTPRequestOperation *operation;

@property(nonatomic, strong)AFHTTPResponseSerializer <AFURLResponseSerialization> *responseSerializer;
+ (instancetype)request;

/**
 *  Interface Path
 *
 *  @return Interface Path
 */
- (NSString *)requestPath;

- (NSDictionary *)parametes;

- (id)parsingData:(id)data;

- (void)startGetRequestWithFinishedBlock:(AFFinishedBlock)finishedBlock;
- (void)startPostRequestWithFinishedBlock:(AFFinishedBlock)finishedBlock;

@end
