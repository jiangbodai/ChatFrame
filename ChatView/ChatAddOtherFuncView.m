//
//  ChatAddOtherFuncView.m
//  ChatFrame
//
//  Created by IVT502 on 16/1/6.
//  Copyright (c) 2016年 Djiangbo. All rights reserved.
//

static NSString *_identifier = @"chatAddOtherFunc";
#define row         4//一共4列
#define KMargin     5//间距
#define KCellWidth ((screenWidth - KMargin * (row + 1))/row)//每个cell的宽度
#define KCellHeight KCellWidth//每个cell的高度


#import "ChatAddOtherFuncView.h"
#import "Common.h"
#import "ZYQAssetPickerController.h"

@interface ChatAddOtherFuncView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *funcsArray;

@end

@implementation ChatAddOtherFuncView

static ChatAddOtherFuncView *_instance = nil;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatInfoViewScrollDown) name:ChatInfoViewScrollDown object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearance) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToRecordNotification) name:ChangeToRecordNotiFication object:nil];
        self.funcsArray = @[@"相片",@"视频",@"表情",@"测试",@"测试",@"测试",@"测试",@"测试"];
        self.frame = CGRectMake(0, screenHeight, screenWidth, (self.funcsArray.count % row) == 0 ? (self.funcsArray.count / row) * (KCellHeight + KMargin) + KMargin : (self.funcsArray.count / row + 1) * (KCellHeight + KMargin) + KMargin);
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(KCellWidth, KCellHeight);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = KMargin;
    flowLayout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, 0, KMargin);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_identifier];
    [self addSubview:collectionView];
}
//聊天视图向下滚动通知
- (void)chatInfoViewScrollDown{
    [self hide];
}
//键盘弹出通知
- (void)keyboardAppearance{
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.y = screenHeight;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//切换到发送语音通知
- (void)changeToRecordNotification{
    [self hide];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:AnimationDuration animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AddOtherFuncWillShow object:@(self.height)];
        self.y = screenHeight - self.height;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:AnimationDuration animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AddOtherFuncWillHide object:@(self.height)];
        self.y = screenHeight;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.funcsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addfunc"]];
    UILabel *firstAidText = [[cell.contentView subviews] lastObject];
    // 判断真实类型
    if (![firstAidText isKindOfClass:[UILabel class]]) {
        firstAidText = [[UILabel alloc] initWithFrame:cell.bounds];
        firstAidText.contentMode = UIViewContentModeScaleToFill;
        firstAidText.clipsToBounds = YES;
        firstAidText.textColor = [UIColor blackColor];
        firstAidText.font = [UIFont systemFontOfSize:15];
        firstAidText.numberOfLines = 0;
        firstAidText.textAlignment = NSTextAlignmentCenter;
        firstAidText.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:firstAidText];
    }
    firstAidText.text = self.funcsArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide];
    ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
    pickerController.maximumNumberOfSelection = 1;
    [self.window.rootViewController presentViewController:pickerController animated:YES completion:nil];
}

- (void)dealloc
{
    [self hide];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
