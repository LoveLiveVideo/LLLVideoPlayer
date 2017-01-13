//
//  PlayerSeekView.h
//  iPhoneVideo
//
//  Created by zhongsheng on 13-10-30.
//  Copyright (c) 2013年 SOHU. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SeekViewIconOrientation){
    SeekViewIconOrientation_Forward,
    SeekViewIconOrientation_Backward,
};

@interface PlayerSeekView : UIView

- (void)reset;

- (void)updateWithPlaybackTime:(CGFloat)playbackTime
                      duration:(CGFloat)durationTime
                   orientation:(SeekViewIconOrientation)orientation;

@end
