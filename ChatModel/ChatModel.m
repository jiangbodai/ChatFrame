//
//  ChatModel.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _chatid = [dict[@"chatid"] intValue];
        _msgid = [dict[@"msgid"] intValue];
        _userid = [dict[@"userid"] intValue];
        _msgType = [dict[@"msgType"] intValue];
        _userpic = dict[@"userpic"];
        _username = dict[@"username"];
        _msgsubmitTime = dict[@"msgsubmitTime"];
        _text = dict[@"text"];
        _mp3url = dict[@"mp3url"];
        _picurl = dict[@"picurl"];
    }
    return self;
}

+ (instancetype)chatModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
