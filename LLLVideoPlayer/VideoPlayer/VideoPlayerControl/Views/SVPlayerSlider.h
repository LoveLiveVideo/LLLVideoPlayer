//
//  SVPlayerSlider.h
//  iPhoneVideo
//
//  Created by yu xiaoxiao on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerPointValue;

typedef void (^SliderPointClickBlock)(PlayerPointValue *value, CGPoint point, UIControlEvents event);

@interface SVPlayerSlider : UISlider

- (void)clickPointEvent:(SliderPointClickBlock)block;

- (void)setDownloadedImage:(UIImage *)image;
- (void)setProcessImage:(UIImage *)image;
- (void)setDownloadedValue:(CGFloat)value;
- (void)setProcessValue:(CGFloat)value;

- (void)addPointsJson:(NSArray*)pointJson;
- (void)removeAllPoints;
- (void)addHeadTail:(NSInteger)headTime Tail:(NSInteger)tailTime;
- (void)removeHeadTailIcon;

- (void)headTailIconShow:(BOOL)show;

@end
