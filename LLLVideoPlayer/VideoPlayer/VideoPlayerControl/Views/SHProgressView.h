//
//  SHProgressView.h
//  iPhoneVideo
//
//  Created by zhongsheng on 14-4-1.
//  Copyright (c) 2014年 SOHU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHProgressView : UIView

@property(nonatomic) CGFloat progress;                        // 0.0 .. 1.0, default is 0.0. values outside are pinned.
@property(nonatomic, retain) UIColor* progressTintColor;
@property(nonatomic, retain) UIColor* trackTintColor;
@property(nonatomic, retain) UIImage* progressImage;
@property(nonatomic, retain) UIImage* trackImage;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
