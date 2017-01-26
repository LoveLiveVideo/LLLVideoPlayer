//
//  ddddd.m
//  fddgd
//
//  Created by ZK on 2017/1/26.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ddddd.h"


@implementation ddddd

+(instancetype)sha
{
    static ddddd* xx= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xx =[[ddddd alloc] init];
    });
    return xx;
}



@end
