//
//  ChatInfoView.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/5.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatInfoView.h"
#import "ChatInfoCell.h"
#import "Common.h"
#import "ChatAddOtherFuncView.h"

@interface ChatInfoView ()<UITableViewDelegate,UITableViewDataSource>{
    int _lastPosition;
}

@end

@implementation ChatInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.tableFooterView = [[UIView alloc] init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearance:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherFuncBtnWillShow:) name:AddOtherFuncWillShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherFuncBtnWillHide) name:AddOtherFuncWillHide object:nil];
        [self loadStatuses];
    }
    return self;
}

- (void)keyboardAppearance:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if (self.contentOffset.y == 0 && self.contentSize.height + keyboardSize.height + KBottomToolBarHeight < self.superview.height) {
        self.height = self.superview.height - keyboardSize.height - KBottomToolBarHeight - 64;
    }else{
        self.y = - keyboardSize.height;
    }
}

- (void)keyboardDismiss:(NSNotification *)noti{
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.y = 0;
    self.height = self.superview.height - KBottomToolBarHeight;
    [UIView commitAnimations];
}

- (void)addOtherFuncBtnWillShow:(NSNotification *)noti{
    CGFloat height = [noti.object floatValue];
    if (self.contentOffset.y == 0 && self.contentSize.height + height + KBottomToolBarHeight < self.superview.height) {
        self.height = self.superview.height - height - KBottomToolBarHeight - 64;
    }else{
        self.y = -height;
    }
}

- (void)addOtherFuncBtnWillHide{
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.y = 0;
        self.height = self.superview.height - KBottomToolBarHeight;
    }];
}

- (void)loadStatuses {
    for (int i = 0; i < 15; i ++) {
        NSDictionary *dict = @{
                               @"chatid":@(arc4random_uniform(10)),
                               @"msgType":@(1),
                               @"msgid":@(i),
                               @"userid":@(arc4random_uniform(2)),
                               @"userpic":@"head",
                               @"username":[NSString stringWithFormat:@"聊天-%d",arc4random_uniform(2)],
                               @"msgsubmitTime":@"2016年1月6日 15:23:56",
                               @"text":@"聊天聊2016年1月6日 15:23:52016年1月6日 15:23:52016年1月6日 15:23:52016年1月6日 15:23:5",
                               @"mp3url":@"",
                               @"picurl":@""
                               };
        ChatModel *model = [ChatModel chatModelWithDict:dict];
        ChatInfoFrame *infoFrame = [[ChatInfoFrame alloc] init];
        infoFrame.chatModel = model;
        [self.chatStatuses addObject:infoFrame];
    }
    [self reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatStatuses.count-1 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatStatuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatInfoCell *cell = [ChatInfoCell cellWithTableView:tableView];
    cell.chatInfoFrame = self.chatStatuses[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatInfoFrame *infoFrame = self.chatStatuses[indexPath.row];
    return infoFrame.cellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 100) {
        _lastPosition = currentPostion;
    }
    else if (_lastPosition - currentPostion > 100)
    {
        _lastPosition = currentPostion;
        [self.superview endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatInfoViewScrollDown object:nil];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)chatStatuses
{
    if (!_chatStatuses) {
        _chatStatuses = [NSMutableArray array];
    }
    return _chatStatuses;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
