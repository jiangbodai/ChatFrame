//
//  ChatInfoFrame.h
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#define msgsubmitTimeFont   [UIFont systemFontOfSize:13]//发送时间字体
#define infoFont            [UIFont systemFontOfSize:15]//聊天详情字体
#define iconWidth           50.0f
#define Kmargin             10.0f

#import <Foundation/Foundation.h>
#import "ChatModel.h"

@interface ChatInfoFrame : NSObject

@property (nonatomic, strong) ChatModel *chatModel;

/**
 *  聊天时间尺寸
 */
@property (nonatomic, assign) CGRect msgsubmitTimeFrame;

/**
 *  用户头像尺寸
 */
@property (nonatomic, assign) CGRect iconFrame;

/**
 *  用户聊天详情尺寸
 */
@property (nonatomic, assign) CGRect infoFrame;

/**
 *  用户聊天背景框尺寸
 */
@property (nonatomic, assign) CGRect bgImageViewFrame;

/**
 *  每行聊天信息高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
