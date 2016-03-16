//
//  GGFResponseEntity.h
//  GraceGreenFarm
//
//  Created by qiangli on 15/2/11.
//  Copyright (c) 2015年 GraceGreenFarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCResponseEntity : NSObject

@property (nonatomic, assign) BOOL  success;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id    data;

@end
