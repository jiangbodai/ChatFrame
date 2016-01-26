//
//  ChatRecordButton.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/22.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

#import "ChatRecordButton.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface ChatRecordButton ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;//录音提示框

@property (nonatomic, strong) UIImageView *hudImageView;//录音提示图片

@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器

@property (nonatomic, strong) NSTimer *timer;//定时器

@property (nonatomic, strong) NSURL *recordFileUrl;//存放录音地址

@property (nonatomic, strong) NSURL *mp3FilePath;//存放mp3文件路径

@end

@implementation ChatRecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}
//开始录音
- (void)startRecord{
    [self record];
}
//取消录音
- (void)cancelRecord{
    [self stop];
    [self alertWithMessage:@"已取消录音"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    });
}
//录音完成
- (void)finishRecord{
    [self stop];
    [self transformCAFToMP3];
}
//录音
- (void)record{
    [self.recorder record];
    [self.hud show:YES];
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}
//停止
- (void)stop{
    [self.hud hide:YES];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.timer invalidate];
    [self.recorder stop];
    self.recorder = nil;

}
NSInteger startTime = 0;
/** 更新音量图片 */
- (void)updateImage {
    startTime ++;
    [self.recorder updateMeters];
    
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    float result  = 10 * (float)lowPassResults;
    int no = 0;
    if (result > 0 && result <= 1.3) {
        no = 1;
    } else if (result > 1.3 && result <= 2) {
        no = 2;
    } else if (result > 2 && result <= 3.0) {
        no = 3;
    } else if (result > 3.0 && result <= 5.0) {
        no = 4;
    } else if (result > 5.0 && result <= 10) {
        no = 5;
    } else if (result > 10 && result <= 40) {
        no = 6;
    } else if (result > 40) {
        no = 7;
    }
    self.hudImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"volunms_%d",no]];
    
    if (startTime % 2 == 0) {
//        if (recordMaxTime - (int)self.recorder.currentTime <= 10) {
//            if ([self.delegate respondsToSelector:@selector(firstaidToolBarViewRecordWillFilish:)]) {
//                [self.delegate firstaidToolBarViewRecordWillFilish:recordMaxTime - (int)self.recorder.currentTime];
//            }
//        }
//        if (recordMaxTime - (int)self.recorder.currentTime == 0){
//            self.isColseRecord = YES;
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                self.recordTime = self.recorder.currentTime;
//                [self stopRecording];
//                [self transformCAFToMP3];
//            });
//        }
        
    }
//    if ([self.delegate respondsToSelector:@selector(firstAidToolBarViewRecordViewDidChangedSound:)]) {
//        [self.delegate firstAidToolBarViewRecordViewDidChangedSound:no];
//    }
}
/** 将录音转化成mp3 */
- (void)transformCAFToMP3 {
    self.mp3FilePath = [self mp3FullFileUrl];
    @try {
        NSInteger read, write;
        FILE *pcm = fopen([[self.recordFileUrl absoluteString] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([[self.mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [[NSNotificationCenter defaultCenter] postNotificationName:FinishRecordNofification object:self.mp3FilePath];
//        NSURL *audioFileSavePath = self.mp3FilePath;
//        UIImage *image = [UIImage imageNamed:@"播放语音11"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.recordTime < 1) {
//                self.recordTime = 1;
//            }
//            if ([self.delegate respondsToSelector:@selector(firstAidToolBarViewrecordSucessedWithImage:recordPath:recordTime:)]) {
//                [self.delegate firstAidToolBarViewrecordSucessedWithImage:image recordPath:audioFileSavePath recordTime:[NSString stringWithFormat:@"%d",(int)self.recordTime]];
//            }
//        });
    }
}

#pragma maek - 录音文件名
/** 根据当前时间获取录音文件名 */
- (NSString *)stringFromDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

/** 录音转化成mp3后的本地路径 */
- (NSURL *)mp3FullFileUrl {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[self stringFromDate]]];
    return [NSURL URLWithString:filePath];
}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:self.window];
    hud.mode = MBProgressHUDModeText;
    hud.cornerRadius = 3.0f;
    hud.labelText = message;
    hud.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    hud.margin = 25.0f;
    [self.window addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0f];
}

#pragma mark - 蓝加载
/** 录音器 */
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        // 真机环境下需要的代码
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        
        // 3.设置录音的一些参数
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        //录音格式 无法使用
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        //采样率
        [recordSettings setValue :[NSNumber numberWithFloat:8000] forKey: AVSampleRateKey];//44100.0
        //通道数
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        //线性采样位数
        [recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
        //音频质量,采样质量
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        
        self.recordFileUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"selfRecord.caf"]];;
        NSError *error = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSettings error:&error];
        if (error) {
            NSLog(@"录音失败%@",error);
        }
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}

- (MBProgressHUD *)hud
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithWindow:self.window];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.opacity = 0.5f;
        _hud.margin = 10.f;
        _hud.cornerRadius = 3.0f;
        _hud.backgroundColor = [UIColor clearColor];
        _hud.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _hud.customView = self.hudImageView;
        [self.window addSubview:_hud];
    }
    return _hud;
}

- (UIImageView *)hudImageView
{
    if (!_hudImageView) {
        _hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        _hudImageView.image = [UIImage imageNamed:@"volunms_1"];
    }
    return _hudImageView;
}

@end
