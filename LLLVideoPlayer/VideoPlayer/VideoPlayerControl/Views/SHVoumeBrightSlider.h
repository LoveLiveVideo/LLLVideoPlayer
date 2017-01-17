//
//  SHVoumeBrightSlider.h
//  VideoPlayerForIphone
//
//  Created by zyh on 16/9/4.
//  Copyright © 2016年 FengHongen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVoumeBrightSlider : UIView

- (instancetype)initBrightSlider; //初始化亮度调节视图

-(instancetype)initWithTopImage:(UIImage *)topImg bottomImage:(UIImage *)bottomImg;

- (void)updateValue:(CGFloat)value;

- (void)addVolumeChangeLinsenter;

- (void)brightViewShow;

- (void)volumeViewShow;

- (void)resetVolumeSource;

@end
