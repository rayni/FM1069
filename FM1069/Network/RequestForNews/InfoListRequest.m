//
//  InfoListRequest.m
//  QunChangMob
//
//  Created by qiangli on 15/6/17.
//  Copyright (c) 2015年 dooban. All rights reserved.
//

#import "InfoListRequest.h"

@implementation InfoListRequest

- (NSString *)requestPath
{
    return @"/informationView/findMainInfoFoMob";
}

- (id)parsingData:(id)data
{
    return data;
}
@end
