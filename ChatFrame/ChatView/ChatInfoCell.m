//
//  ChatInfoCell.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatInfoCell.h"
#import "ChatInfoButton.h"

@interface ChatInfoCell ()

@property (nonatomic, weak) UILabel *msgsubmitTime;//消息发送时间

@property (nonatomic, weak) UIImageView *icon;//用户头像

@property (nonatomic, weak) ChatInfoButton *info;//聊天详情

@property (nonatomic, weak) UIImageView *bgImageView;//聊天框

@end

@implementation ChatInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"chatCell";
    ChatInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ChatInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor lightTextColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    UILabel *msgsubmitTime = [[UILabel alloc] init];
    msgsubmitTime.font = msgsubmitTimeFont;
    msgsubmitTime.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:msgsubmitTime];
    self.msgsubmitTime = msgsubmitTime;
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.layer.cornerRadius = iconWidth * 0.5;
    icon.layer.masksToBounds = YES;
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    ChatInfoButton *info = [[ChatInfoButton alloc] init];
    info.titleLabel.font = infoFont;
    info.titleLabel.numberOfLines = 0;
    info.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [info setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:info];
    self.info = info;
}

- (void)setChatInfoFrame:(ChatInfoFrame *)chatInfoFrame
{
    _chatInfoFrame = chatInfoFrame;
    BOOL isSelf = (_chatInfoFrame.chatModel.userid == loginUserid) ? 1 : 0;
    
    self.msgsubmitTime.frame = _chatInfoFrame.msgsubmitTimeFrame;
    self.msgsubmitTime.text = _chatInfoFrame.chatModel.msgsubmitTime;
    
    self.icon.frame = _chatInfoFrame.iconFrame;
    self.icon.image = [UIImage imageNamed:_chatInfoFrame.chatModel.userpic];
    
    self.info.frame = _chatInfoFrame.infoFrame;
    self.info.infoFrame = _chatInfoFrame;
    
    self.bgImageView.frame = _chatInfoFrame.bgImageViewFrame;
    UIImage *image = nil;
    if (isSelf) {
        image = [UIImage imageNamed:@"对话框1"];
    }else{
        image = [UIImage imageNamed:@"对话框"];
    }
    self.bgImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


@end
