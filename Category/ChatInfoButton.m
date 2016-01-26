//
//  ChatInfoButton.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/22.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatInfoButton.h"
#import "ChatInfoFrame.h"
#import "ChatModel.h"
#import <AVFoundation/AVFoundation.h>

@interface ChatInfoButton ()<AVAudioPlayerDelegate>{
    NSData *_voiceData;
}

@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation ChatInfoButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.enabled = NO;
        self.imageView.animationDuration = 0.8f;
        [self addTarget:self action:@selector(chatInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setInfoFrame:(ChatInfoFrame *)infoFrame
{
    _infoFrame = infoFrame;
    if (_infoFrame.chatModel.msgType == 1) {
        [self setTitle:_infoFrame.chatModel.text forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        self.layer.transform =  CATransform3DMakeRotation(0, 0, 0, 0);
    }else if (_infoFrame.chatModel.msgType == 2){
        [self setTitle:nil forState:UIControlStateNormal];
        [self setImage:_infoFrame.chatModel.picImage forState:UIControlStateNormal];
    }else if (_infoFrame.chatModel.msgType == 3){
        [self setTitle:nil forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"fs_icon_wave_2"] forState:UIControlStateNormal];
        if (_infoFrame.chatModel.userid == loginUserid) {
            self.layer.transform =  CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
        }else{
            self.layer.transform =  CATransform3DMakeRotation(0, 0, 0, 0);
        }
        _voiceData = [NSData dataWithContentsOfFile:_infoFrame.chatModel.mp3url];
        if (_voiceData != nil) {
            self.enabled = YES;
        }
    }
}

- (void)chatInfoButtonClicked:(UIButton *)button{
    if (self.infoFrame.chatModel.msgType == 1) {
        NSLog(@"文本");
    }else if (self.infoFrame.chatModel.msgType == 2){
        NSLog(@"图片");
    }else if (self.infoFrame.chatModel.msgType == 3){
        if (self.player.playing && self.imageView.isAnimating) {
            [self stop];
        }else{
            [self play];
        }
    }
}
#pragma mark - AVAudioPlayer Delegate

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    [self play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopAnimating];
}

#pragma mark - Public
- (void)startAnimating
{
    if (!self.imageView.isAnimating) {
        NSArray *array =  @[
                            [UIImage imageNamed:@"fs_icon_wave_0@2x"],
                            [UIImage imageNamed:@"fs_icon_wave_1@2x"],
                            [UIImage imageNamed:@"fs_icon_wave_2@2x"]
                            ];
        self.imageView.animationImages = array;
        [self.imageView startAnimating];
    }
}

- (void)stopAnimating
{
    if (self.imageView.isAnimating) {
        [self.imageView stopAnimating];
    }
}

- (void)play
{
    if (!_voiceData) {
        NSLog(@"ContentURL of voice bubble was not set");
        return;
    }
    if (!_player.playing) {
        [_player play];
        [self startAnimating];
    }
}

- (void)pause
{
    if (_player.playing) {
        [_player pause];
        [self stopAnimating];
    }
}

- (void)stop
{
    if (_player.playing) {
        [_player stop];
        _player.currentTime = 0;
        [self stopAnimating];
    }
}




#pragma mark - 懒加载
- (AVAudioPlayer *)player
{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithData:_voiceData fileTypeHint:AVFileTypeMPEGLayer3  error:NULL];
        _player.delegate = self;
        [_player prepareToPlay];
    }
    return _player;
}

@end
