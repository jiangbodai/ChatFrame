//
//  ChatNet.h
//  ChatFrame
//
//  Created by IVT502 on 16/1/6.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatModel;

@interface ChatNet : NSObject
//发送消息
+ (void)sendMessage:(ChatModel *)chatModel Callback:(void(^)(NSDictionary *dict))callBack;

@end
