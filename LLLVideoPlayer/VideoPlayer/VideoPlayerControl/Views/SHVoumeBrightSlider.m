//
//  SHVoumeBrightSlider.m
//  VideoPlayerForIphone
//
//  Created by zyh on 16/9/4.
//  Copyright © 2016年 FengHongen. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

//#import "SHVideoPlayerViewHierarchy.h"
//#import "SHVideoPlayerViewController+PlayVideo.h"
//#import "SHVideoPlayerViewController_iPhone+Floating.h"

#import "SHVoumeBrightSlider.h"
#import "UIView+Sizes.h"

static BOOL isVolumeChangedByDeviceSideButton;

static void sliderVolumeChangeCallback(void *nClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData);

@interface SHVoumeBrightSlider ()
{
    UIImage *_topImage;
    UIImage *_bottomImage;
    
    UIImageView *_logoImageView;
    UIView *_bgView;
    UIView *_progressView;
    
    CGFloat _value;
}

@property (nonatomic, strong) NSTimer *hideTimer;

@end

@implementation SHVoumeBrightSlider

- (void)dealloc
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, (AudioSessionPropertyListener)sliderVolumeChangeCallback, (__bridge void *)self);
}

- (instancetype)initBrightSlider
{
    return [self initWithTopImage:[UIImage imageNamed:@"Play-Icon-BrightnessUp"] bottomImage:[UIImage imageNamed:@"Play-Icon-BrightnessDown"] backgroundAlpha:0.0];
}

-(instancetype)initWithTopImage:(UIImage *)topImg bottomImage:(UIImage *)bottomImg backgroundAlpha:(CGFloat)alpha
{
    if (self = [super init])
    {
        isVolumeChangedByDeviceSideButton = YES;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        
        _topImage = topImg;
        _bottomImage = bottomImg;
        
        _logoImageView = [[UIImageView alloc] initWithImage:topImg];
        [self addSubview:_logoImageView];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_progressView];
    }
    return self;
}

-(instancetype)initWithTopImage:(UIImage *)topImg bottomImage:(UIImage *)bottomImg;
{
    return [self initWithTopImage:topImg bottomImage:bottomImg backgroundAlpha:0.3];
}

- (void)resetVolumeSource
{
    isVolumeChangedByDeviceSideButton = YES;
}

- (void)updateValue:(CGFloat)value
{
    value = MAX(0, value);
    value = MIN(1, value);
    _value = value;
    if (value <= 0) {
        _logoImageView.image = _bottomImage;
    } else {
        _logoImageView.image = _topImage;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGFloat y = (frame.size.height - (_logoImageView.height + 25 + 2)) / 2;
    _logoImageView.frame = CGRectMake((frame.size.width - _logoImageView.width) / 2, y, _logoImageView.width, _logoImageView.height);
    CGFloat h = 2.0;
    _bgView.frame = CGRectMake((frame.size.width - 110) / 2, _logoImageView.bottom + 25, 110, h);
    _progressView.frame = CGRectMake(0, 0, _bgView.width * _value, h);
}

#pragma mark - 音量变化相关
- (void)addVolumeChangeLinsenter
{
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                    (AudioSessionPropertyListener)sliderVolumeChangeCallback,
                                    (__bridge void *)self);
}

- (void)volumeViewShow
{
//    if (![SHVideoPlayerViewController_iPhone isBeingShowed]) {
//        return;
//    }
//    
//    //[self registerTimer]; zbl slider
//    isVolumeChangedByDeviceSideButton = NO;
//    
//    SHVideoPlayerViewController_iPhone *videoPlayerVc = [SHVideoPlayerViewController_iPhone defaultVideoPlayerViewController];
//    SHVideoPlayerView *playerView = videoPlayerVc.videoPlayerView;
//    if (!self.superview) {
//        [videoPlayerVc.videoPlayerView.viewHierarchy addSubView:self forLevel:PlayerViewHierarchyLevelControl];
//    }
//
//    self.frame = playerView.bounds;
}

#pragma mark - 亮度相关
- (void)brightViewShow
{
//    if (![SHVideoPlayerViewController_iPhone isBeingShowed]) {
//        return;
//    }
//    //[self registerTimer]; zbl slider
//    SHVideoPlayerViewController_iPhone *videoPlayerVc = [SHVideoPlayerViewController_iPhone defaultVideoPlayerViewController];
//    SHVideoPlayerView *playerView = videoPlayerVc.videoPlayerView;
//    if (!self.superview) {
//        [videoPlayerVc.videoPlayerView.viewHierarchy addSubView:self forLevel:PlayerViewHierarchyLevelControl];
//    }
//    self.frame = playerView.bounds;
}

#pragma mark - 定时器
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.hideTimer invalidate];
        self.hideTimer = nil;
    }
}

- (void)registerTimer
{
    if (self.hideTimer) {
        [self.hideTimer invalidate];
    }
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
}

- (void)timerFired
{
    [self.hideTimer invalidate];
    self.hideTimer = nil;
    [self removeFromSuperview];
}

@end

static void sliderVolumeChangeCallback(void *nClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData) {
//    const float *volumePointer = inData;
//    float value = *volumePointer;
//    
//    SHVideoPlayerViewController_iPhone *videoPlayerVc = [SHVideoPlayerViewController_iPhone defaultVideoPlayerViewController];
//    if ([videoPlayerVc isFloatingPlayer]) {
//        return;
//    }
//    
//    dispatch_in_mainthread(^{
//        SHVoumeBrightSlider *slider = (__bridge SHVoumeBrightSlider *)nClientData;
//        if (![SHVideoPlayerViewController_iPhone isBeingShowed]) {
//            return;
//        }
//        //[slider registerTimer]; zbl slider
//        if (isVolumeChangedByDeviceSideButton)
//        {
//            [slider registerTimer];
//        }
//        
//        SHVideoPlayerViewController_iPhone *videoPlayerVc = [SHVideoPlayerViewController_iPhone defaultVideoPlayerViewController];
//        SHVideoPlayerView *playerView = videoPlayerVc.videoPlayerView;
//        if (!slider.superview) {
//            if (videoPlayerVc.videoPlayer.isPreparedToPlay) {
//                [videoPlayerVc.videoPlayerView.viewHierarchy addSubView:slider forLevel:PlayerViewHierarchyLevelControl];
//            }
//        }
//        slider.frame = playerView.bounds;
//        [slider updateValue:value];
//    });
}
