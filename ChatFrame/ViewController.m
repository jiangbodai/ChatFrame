//
//  ViewController.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/4.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ViewController.h"
#import "ChatBottomToolBar.h"
#import "ChatInfoView.h"
#import "Common.h"
#import "ChatAddOtherFuncView.h"
#import "ZYQAssetPickerController.h"
#import "ChatModel.h"
#import "ChatInfoFrame.h"
#import "NSDate+ChatDate.h"

@interface ViewController ()

@property (nonatomic, strong) ChatBottomToolBar *bottomToolBar;//底部工具条

@property (nonatomic, strong) ChatInfoView *infoView;//聊天信息视图

@property (nonatomic, strong) ChatAddOtherFuncView *addOtherFunc;//添加其他信息

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天室";
    self.edgesForExtendedLayout = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOtherFuncBtnClicked) name:AddOtherFuncString object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishSelectPicNotification:) name:FinishSelectPicNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishWriteContentNotification:) name:FinishWriteContentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishRecordNofification:) name:FinishRecordNofification object:nil];
    [self.view addSubview:self.bottomToolBar];
    [self.view addSubview:self.infoView];
}
//聊天界面刷新数据并滚动到最后一条信息
- (void)tableViewReloadDateAndScrollToBottom:(ChatInfoFrame *)infoFrame {
    [self.infoView.chatStatuses insertObject:infoFrame atIndex:self.infoView.chatStatuses.count];
    [self.infoView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.infoView.chatStatuses.count-1 inSection:0];
    [self.infoView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)FinishSelectPicNotification:(NSNotification *)noti{
    NSArray *array = noti.object;
    ALAsset *asset = array.firstObject;
    //等比例缩略图
    CGImageRef ratioThum = [asset aspectRatioThumbnail];
    UIImage* rti = [UIImage imageWithCGImage:ratioThum];
    
    ChatInfoFrame *infoFrame = [[ChatInfoFrame alloc] init];
    ChatModel *model = [[ChatModel alloc] init];
    model.msgsubmitTime = [NSDate currentTime];
    model.msgType = 2;
    model.userid = loginUserid;
    model.picImage = rti;
    model.userpic = @"head";
    infoFrame.chatModel = model;
    [self tableViewReloadDateAndScrollToBottom:infoFrame];
    [self automaticAnswerWithMessage:infoFrame];
}

- (void)FinishWriteContentNotification:(NSNotification *)noti{
    ChatInfoFrame *infoFrame = [[ChatInfoFrame alloc] init];
    ChatModel *model = [[ChatModel alloc] init];
    model.msgsubmitTime = [NSDate currentTime];
    model.userid = loginUserid;
    model.msgType = 1;
    model.text = noti.object;
    model.userpic = @"head";
    infoFrame.chatModel = model;
    [self tableViewReloadDateAndScrollToBottom:infoFrame];
    [self automaticAnswerWithMessage:infoFrame];
}

- (void)FinishRecordNofification:(NSNotification *)noti{
    NSURL *mp3Url = noti.object;
    ChatInfoFrame *infoFrame = [[ChatInfoFrame alloc] init];
    ChatModel *model = [[ChatModel alloc] init];
    model.msgsubmitTime = [NSDate currentTime];
    model.userid = loginUserid;
    model.msgType = 3;
    model.mp3url = mp3Url.absoluteString;
    model.userpic = @"head";
    infoFrame.chatModel = model;
    [self tableViewReloadDateAndScrollToBottom:infoFrame];
    [self automaticAnswerWithMessage:infoFrame];
}

- (void)automaticAnswerWithMessage:(ChatInfoFrame *)message{
    ChatInfoFrame *infoFrame = [[ChatInfoFrame alloc] init];
    ChatModel *model = [[ChatModel alloc] init];
    model.msgsubmitTime = [NSDate currentTime];
    model.userid = 0;
    model.msgType = message.chatModel.msgType;
    model.mp3url = message.chatModel.mp3url;
    model.picImage = message.chatModel.picImage;
    model.text = @"自动回复";
    model.userpic = @"head";
    infoFrame.chatModel = model;
    [self tableViewReloadDateAndScrollToBottom:infoFrame];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)addOtherFuncBtnClicked {
    [self.addOtherFunc show];
}

#pragma mark - 懒加载
- (ChatBottomToolBar *)bottomToolBar
{
    if (!_bottomToolBar) {
        _bottomToolBar = [[ChatBottomToolBar alloc] initWithFrame:CGRectMake(0, screenHeight - KBottomToolBarHeight - 64, self.view.width, KBottomToolBarHeight)];
        _bottomToolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomToolBar;
}

- (ChatInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[ChatInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, screenHeight - KBottomToolBarHeight - 64)];
    }
    return _infoView;
}

- (ChatAddOtherFuncView *)addOtherFunc
{
    if (!_addOtherFunc) {
        _addOtherFunc = [[ChatAddOtherFuncView alloc] init];
    }
    return _addOtherFunc;
}

@end
