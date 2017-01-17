//
//  NSString+time.m
//  iPhoneVideo
//
//  Created by zhongsheng on 13-11-6.
//  Copyright (c) 2013年 SOHU. All rights reserved.
//

#import "NSString+time.h"

@implementation NSString (time)

+ (NSString *)timeStringFromTime:(CGFloat)playTime {
	NSInteger nHours = (NSInteger)(playTime/3600);
	playTime -= nHours *3600;
	NSInteger nMinutes = (NSInteger)(playTime/60);
	playTime -= nMinutes*60;
	NSInteger nSeconds = (NSInteger)playTime%60;
	if(nSeconds <= 0)
		nSeconds = 0;
	
	NSMutableString*strRet = [NSMutableString stringWithFormat:@"%2ld:%2ld",(long)(nHours*60+nMinutes),(long)nSeconds];
	[strRet replaceOccurrencesOfString:@" " withString:@"0" options:NSLiteralSearch
								 range:NSMakeRange(0, [strRet length])];
	return [NSString stringWithString:strRet];
}

+ (NSString *)accessibilityTimeStringFromTime:(CGFloat)playTime {
    NSInteger nHours = (NSInteger)(playTime/3600);
    playTime -= nHours *3600;
    NSInteger nMinutes = (NSInteger)(playTime/60);
    playTime -= nMinutes*60;
    NSInteger nSeconds = (NSInteger)playTime%60;
    if(nSeconds <= 0)
        nSeconds = 0;
    NSMutableString*strRet = [NSMutableString stringWithFormat:@"%2ld分%2ld秒",(long)(nHours*60+nMinutes),(long)nSeconds];
    return [NSString stringWithString:strRet];
}

+ (NSString *)formatVideoTimeLength:(NSString *)videoTimeLength {
    NSInteger timeLength = [videoTimeLength integerValue];
    NSInteger hours = timeLength / 3600;
    timeLength -= hours * 3600;
    NSInteger minutes = timeLength / 60;
    timeLength -= minutes * 60;
    NSInteger seconds = timeLength;

    NSString *formatTimeLength = nil;
    if (hours > 0) {
        formatTimeLength = [NSString stringWithFormat:@"%ld小时%ld分%ld秒", (long)hours, (long)minutes, (long)seconds];
    }
    else if (minutes > 0) {
        formatTimeLength = [NSString stringWithFormat:@"%ld分%ld秒", (long)minutes, (long)seconds];
    }
    else {
        formatTimeLength = [NSString stringWithFormat:@"%ld秒", (long)seconds];
    }
    
    return formatTimeLength;
}

@end
