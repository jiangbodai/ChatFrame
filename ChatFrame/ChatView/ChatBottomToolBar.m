//
//  ChatBottomToolBar.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/4.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatBottomToolBar.h"
#import "Common.h"

#define Kmargin 5//间隙

@interface ChatBottomToolBar ()<UITextViewDelegate>

@property (nonatomic, weak) UIButton *changeChatType;//更换聊天方式按钮

@property (nonatomic, weak) UITextView *writeChat;//文字聊天

@property (nonatomic, weak) ChatRecordButton *recordChat;//语音聊天按钮

@property (nonatomic, weak) UIButton *addOther;//发送按钮

@end

@implementation ChatBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearance:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismissMode) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherFuncViewWillShow:) name:AddOtherFuncWillShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherFuncViewWillHide) name:AddOtherFuncWillHide object:nil];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    UIButton *changeChatType = [[UIButton alloc] init];
    [changeChatType setImage:[UIImage imageNamed:@"语音图标_1"] forState:UIControlStateNormal];
    [changeChatType setImage:[UIImage imageNamed:@"keyboard_on_select"] forState:UIControlStateSelected];
    [changeChatType addTarget:self action:@selector(changeChatTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeChatType];
    self.changeChatType = changeChatType;
    
    UITextView *writeChat = [[UITextView alloc] init];
    writeChat.font = [UIFont systemFontOfSize:15];
    writeChat.returnKeyType = UIReturnKeySend;
    writeChat.showsHorizontalScrollIndicator = NO;
    writeChat.showsVerticalScrollIndicator = NO;
    writeChat.delegate = self;
    writeChat.layer.cornerRadius = 10.0;
    writeChat.layer.borderColor = [UIColor whiteColor].CGColor;
    writeChat.layer.borderWidth = 1.0f;
    writeChat.layer.masksToBounds = YES;
    [self addSubview:writeChat];
    self.writeChat = writeChat;
    
    ChatRecordButton *recordChat = [[ChatRecordButton alloc] init];
    recordChat.layer.cornerRadius = 10.0;
    recordChat.layer.masksToBounds = YES;
    recordChat.layer.borderWidth = 1.0f;
    recordChat.layer.borderColor = [UIColor whiteColor].CGColor;
    recordChat.backgroundColor = [UIColor whiteColor];
    [recordChat setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [recordChat setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [recordChat setTitle:@"按住 说话" forState:UIControlStateNormal];
    [recordChat setTitle:@"松开 发送" forState:UIControlStateHighlighted];
    recordChat.hidden = YES;
    [self addSubview:recordChat];
    self.recordChat = recordChat;
    
    UIButton *addOther = [[UIButton alloc] init];
    [addOther setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addOther addTarget:self action:@selector(addOtherFuncs:) forControlEvents:UIControlEventTouchUpInside];
    [addOther setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addOther setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [addOther setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self addSubview:addOther];
    self.addOther = addOther;
}

- (void)changeChatTypeBtnClicked:(UIButton *)button{
    if (button.selected == YES) {
        button.selected = NO;
        self.recordChat.hidden = YES;
        self.writeChat.hidden = NO;
        [self.writeChat becomeFirstResponder];
    }else{
        button.selected = YES;
        self.recordChat.hidden = NO;
        self.writeChat.hidden = YES;
        self.writeChat.text = nil;
        [self endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeToRecordNotiFication object:nil];
    }
}

//发送
- (void)addOtherFuncs:(UIButton *)button {
    [self.writeChat endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:AddOtherFuncString object:button];
}

//键盘弹出
- (void)keyboardAppearance:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.y = screenHeight - self.height - keyboardSize.height - 64;
    }];
}
//键盘隐藏
- (void)keyboardDismissMode{
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.y = screenHeight - self.height - 64;
    }];
}
//添加其他视图弹出
- (void)addOtherFuncViewWillShow:(NSNotification *)noti{
    CGFloat height = [noti.object floatValue];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.y = screenHeight - self.height - height - 64;
    }];
}

//添加其他视图将要隐藏
- (void)addOtherFuncViewWillHide{
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.y = screenHeight - self.height - 64;
    }];
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessages];
        return NO;
    }
    return YES;
}

- (void)sendMessages{
    if (self.writeChat.text.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FinishWriteContentNotification object:self.writeChat.text];
        self.writeChat.text = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.changeChatType.frame = CGRectMake(Kmargin, 4, self.height - 8, self.height - 8);
    self.addOther.frame = CGRectMake(self.width - Kmargin - (self.height - 8), 4, self.height - 8, self.height - 8);
    self.writeChat.frame = CGRectMake(CGRectGetMaxX(self.changeChatType.frame) +Kmargin, 4, self.addOther.x - CGRectGetMaxX(self.changeChatType.frame) - Kmargin * 2, self.height - 8);
    self.recordChat.frame = self.writeChat.frame;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
