//
//  ChatInfoCell.h
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInfoFrame.h"

@interface ChatInfoCell : UITableViewCell

@property (nonatomic, strong) ChatInfoFrame *chatInfoFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
