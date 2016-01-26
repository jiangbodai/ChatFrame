//
//  ChatModel.h
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, assign) int chatid;//跟哪个用户聊天的聊天id

@property (nonatomic, assign) int msgid;//该条消息的id

@property (nonatomic, assign) int userid;//参与聊天的用户id

@property (nonatomic, assign) int msgType;//聊天信息的类型

@property (nonatomic, copy) NSString *userpic;//该消息用户头像地址

@property (nonatomic, copy) NSString *username;//该消息用户姓名

@property (nonatomic, copy) NSString *msgsubmitTime;//消息上传时间

@property (nonatomic, copy) NSString *text;//文字描述

@property (nonatomic, strong) NSString *mp3url;//语音地址

@property (nonatomic, strong) NSString *picurl;//图片地址

@property (nonatomic, strong) UIImage *picImage;

@property (nonatomic, assign, getter=isPlaying) BOOL playing;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)chatModelWithDict:(NSDictionary *)dict;

@end
