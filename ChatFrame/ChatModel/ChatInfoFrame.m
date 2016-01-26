//
//  ChatInfoFrame.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatInfoFrame.h"

@implementation ChatInfoFrame

- (void)setChatModel:(ChatModel *)chatModel
{
    _chatModel = chatModel;
    //判断是否为自己本人
    BOOL isSelf = (_chatModel.userid == loginUserid) ? 1: 0;
    
    //计算时间尺寸
    CGSize msgsubmitTimeSize = CGSizeMake(screenWidth, MAXFLOAT);
    CGRect msgsubmitTimeRect = [_chatModel.msgsubmitTime boundingRectWithSize:msgsubmitTimeSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : msgsubmitTimeFont} context:nil];
    _msgsubmitTimeFrame = CGRectMake((screenWidth - msgsubmitTimeRect.size.width) * 0.5, 0, msgsubmitTimeRect.size.width, msgsubmitTimeRect.size.height);
    
    //计算用户头像尺寸
    CGFloat iconX = 0;
    if (isSelf) {
        iconX = screenWidth - iconWidth - Kmargin;
    }else{
        iconX = Kmargin;
    }
    _iconFrame = CGRectMake(iconX, CGRectGetMaxY(_msgsubmitTimeFrame) + 2 * Kmargin, iconWidth, iconWidth);
    
    //计算聊天信息的尺寸
    CGSize infoSize = CGSizeMake(screenWidth - iconWidth * 2 - Kmargin * 2, MAXFLOAT);
    CGRect infoRect = CGRectZero;
    if (_chatModel.msgType == 1) {
        infoRect = [_chatModel.text boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : infoFont} context:nil];
        if (infoRect.size.height < 30) {
            infoRect.size.height = 30;
        }
    }else if (_chatModel.msgType == 2){
        infoRect = CGRectMake(0, 0, _chatModel.picImage.size.width * 0.5, _chatModel.picImage.size.height * 0.5);
    }else if (_chatModel.msgType == 3){
        infoRect = CGRectMake(0, 0, 100, 30);
    }
    if (isSelf) {
        _infoFrame = CGRectMake(_iconFrame.origin.x - infoRect.size.width - Kmargin, _iconFrame.origin.y + Kmargin * 2, infoRect.size.width, infoRect.size.height);
    }else{
        _infoFrame = CGRectMake(CGRectGetMaxX(_iconFrame) + Kmargin, _iconFrame.origin.y + Kmargin * 2, infoRect.size.width, infoRect.size.height);
    }
    
    //计算聊天背景框尺寸
    if (isSelf) {
        _bgImageViewFrame = CGRectMake(_iconFrame.origin.x - infoRect.size.width - Kmargin * 2, _infoFrame.origin.y - Kmargin * 0.5, _infoFrame.size.width + Kmargin * 2, _infoFrame.size.height + Kmargin);
    }else{
        _bgImageViewFrame = CGRectMake(CGRectGetMaxX(_iconFrame), _infoFrame.origin.y - Kmargin * 0.5, _infoFrame.size.width + Kmargin * 2, _infoFrame.size.height + Kmargin);
    }
    
    //每行聊天信息高度
    _cellHeight = CGRectGetMaxY(_bgImageViewFrame) + Kmargin;
}

@end
