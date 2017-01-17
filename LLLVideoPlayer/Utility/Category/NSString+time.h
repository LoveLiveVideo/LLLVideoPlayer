//
//  NSString+time.h
//  iPhoneVideo
//
//  Created by zhongsheng on 13-11-6.
//  Copyright (c) 2013年 SOHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (time)

+ (NSString *)timeStringFromTime:(CGFloat)playTime;

+ (NSString *)accessibilityTimeStringFromTime:(CGFloat)playTime;

+ (NSString *)formatVideoTimeLength:(NSString *)videoTimeLength;

@end
