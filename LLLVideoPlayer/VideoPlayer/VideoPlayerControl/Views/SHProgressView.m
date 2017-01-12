//
//  SHProgressView.m
//  iPhoneVideo
//
//  Created by zhongsheng on 14-4-1.
//  Copyright (c) 2014年 SOHU. All rights reserved.
//

#import "SHProgressView.h"

@interface SHProgressView ()
@property (nonatomic, retain) UIImageView *trackImageView;
@property (nonatomic, retain) UIImageView *progressImageView;
@end

@implementation SHProgressView

- (void)dealloc
{
    self.progressTintColor = nil;
    self.trackTintColor = nil;
    self.progressImage = nil;
    self.trackImage = nil;
    self.trackImageView = nil;
    self.progressImageView = nil;
    self.frame = CGRectZero;
    self.bounds = CGRectZero;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.trackImageView];
        [_trackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self addSubview:self.progressImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.trackImageView.frame = self.bounds;
    [self setProgress:self.progress];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.1f];
    }
    self.progress = progress;
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < .0f) {
        progress = .0f;
    }
    if (!isnan(progress)) {
        _progress = progress;
        CGRect progressFrame = self.bounds;
        progressFrame.size.width *= _progress;
        self.progressImageView.frame = progressFrame;
        [self.progressImageView setNeedsDisplay];
    }
}

- (void)setProgressImage:(UIImage *)progressImage
{
    if (progressImage != _progressImage) {
        _progressImage = progressImage;
        if (progressImage) {
            self.progressImageView.image = progressImage;
        }
    }
}

- (void)setTrackImage:(UIImage *)trackImage
{
    if (trackImage != _trackImage) {
        _trackImage = trackImage;
        if (trackImage) {
            self.trackImageView.image = trackImage;
        }
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if (progressTintColor != _progressTintColor) {
        _progressTintColor = progressTintColor;
        
        self.progressImageView.backgroundColor = progressTintColor;
    }
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    if (trackTintColor != _trackTintColor) {
        _trackTintColor = trackTintColor;
        
        self.trackImageView.backgroundColor = trackTintColor;
    }
}

#pragma mark - Private

- (UIImageView *)trackImageView
{
    if (!_trackImageView) {
        _trackImageView = [[UIImageView alloc] init];
    }
    return _trackImageView;
}

- (UIImageView *)progressImageView
{
    if (!_progressImageView) {
        _progressImageView = [[UIImageView alloc] init];
    }
    return _progressImageView;
}

@end
