//
//  PlayerSeekView.m
//  iPhoneVideo
//
//  Created by zhongsheng on 13-10-30.
//  Copyright (c) 2013年 SOHU. All rights reserved.
//

#import "PlayerSeekView.h"
#import "TTTAttributedLabel.h"
#import "NSString+time.h"

#define PlayerSeekView_Width 130.0f
#define PlayerSeekView_Height 91
#define PlayerSeekViewFrame  CGRectMake(0.0f,0.0f,PlayerSeekView_Width, PlayerSeekView_Height)
#define PlayerSeekIconFrame  CGRectMake((PlayerSeekView_Width - 43) / 2, 0, 43, 35)
#define PlayerSeekTitleFrame CGRectMake(0, 35 + 25,PlayerSeekView_Width, 20)
#define PlayerSeekProgressFrame CGRectMake(0, 35 + 25 + 20 + 10,PlayerSeekView_Width, 1)

@interface PlayerSeekProgressView : UIView
{
    CAGradientLayer *_gradientLayer;
}

- (void)setProgress:(CGFloat)progress;

@end

@implementation PlayerSeekProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"c1304f"].CGColor, (__bridge id)[UIColor colorWithHexString:@"f7aa55"].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.frame = CGRectMake(0, 0, 1, frame.size.height);
        [self.layer addSublayer:_gradientLayer];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    CGRect frame = _gradientLayer.frame;
    if (progress > 1) {
        frame = self.bounds;
    } else if (progress < 0) {
        frame.size.width = 0;
    } else {
        frame.size.width = self.bounds.size.width * progress;
    }
    _gradientLayer.frame = frame;
}

@end

@interface PlayerSeekView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) PlayerSeekProgressView *progressView;
@end

@implementation PlayerSeekView

- (id)initWithFrame:(CGRect)frame
{
    frame = PlayerSeekViewFrame;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.iconImageView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.progressView];
    }
    return self;
}

#pragma mark - Public

- (void)updateWithPlaybackTime:(CGFloat)playbackTime
                      duration:(CGFloat)durationTime
                   orientation:(SeekViewIconOrientation)orientation
{
    if (SeekViewIconOrientation_Backward == orientation ) {
        self.iconImageView.image = [UIImage imageNamed:@"PlayerFullScreen-Icon-SeekBackward"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"PlayerFullScreen-Icon-SeekForward"];
    }
    if (durationTime <= 0) {
        [self.progressView setProgress:0];
    } else {
        [self.progressView setProgress:playbackTime / durationTime];
    }
    UIFont *font = self.timeLabel.font;
    CTTextAlignment alignment = kCTCenterTextAlignment;
    CTLineBreakMode lineBreakMode = kCTLineBreakByClipping;
    
    if ([NSMutableParagraphStyle class]) {
        //fix issue IPHONE-6981 ios 10 没有快进快退时间显示
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:[NSString timeStringFromTime:playbackTime]
                                                                                     attributes:@{
                                                                                                  NSParagraphStyleAttributeName : paragraphStyle,
                                                                                                  NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#ff382e"],
                                                                                                  NSFontAttributeName : font
                                                                                                  }];
        NSMutableAttributedString *durationText = [[NSMutableAttributedString alloc] initWithString:[@"/" stringByAppendingString:[NSString timeStringFromTime:durationTime]]
                                                                                         attributes:@{
                                                                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                      NSFontAttributeName : font
                                                                                                      }];
        [timeText appendAttributedString: durationText];
        
        self.timeLabel.attributedText = timeText;
    }else{
        CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName,font.pointSize,NULL);
        CTParagraphStyleSetting paragraphStyles[2] = {
            {.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void *)&alignment},
            {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void *)&lineBreakMode},
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphStyles, 2);
        
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc]
                                               initWithString:[NSString timeStringFromTime:playbackTime]
                                               attributes:
                                               @{
                                                 (NSString *)(kCTForegroundColorAttributeName) : (id)[UIColor colorWithHexString:@"#ff382e"].CGColor,
                                                 (NSString *)(kCTFontAttributeName) : (__bridge id)ctFont,
                                                 (NSString *)kCTParagraphStyleAttributeName : (id)paragraphStyle
                                                 }];
        
        NSMutableAttributedString *durationText = [[NSMutableAttributedString alloc]
                                                   initWithString:[@"/" stringByAppendingString:[NSString timeStringFromTime:durationTime]]
                                                   attributes:
                                                   @{
                                                     (NSString *)(kCTForegroundColorAttributeName) : (id)[UIColor whiteColor].CGColor,
                                                     (NSString *)(kCTFontAttributeName) : (__bridge id)ctFont,
                                                     (NSString *)kCTParagraphStyleAttributeName : (id)paragraphStyle
                                                     }];
        [timeText appendAttributedString:durationText];
        CFRelease(ctFont);
        CFRelease(paragraphStyle);
        self.timeLabel.attributedText = timeText;
    }
    
}

- (void)reset
{
    self.timeLabel.text = nil;
}

#pragma mark - Propertys

- (UIImageView *)iconImageView
{
    if (nil == _iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:PlayerSeekIconFrame];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)timeLabel
{
    if (nil == _timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:PlayerSeekTitleFrame];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _timeLabel;
}

-(PlayerSeekProgressView *)progressView
{
    if (nil == _progressView) {
        _progressView = [[PlayerSeekProgressView alloc] initWithFrame:PlayerSeekProgressFrame];
    }
    return _progressView;
}

@end
