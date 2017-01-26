//
//  UINavigationController+swtich.m
//  fddgd
//
//  Created by ZK on 2017/1/26.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "UINavigationController+swtich.h"

@implementation UINavigationController (swtich)

// 支持转屏
-(BOOL)shouldAutorotate
{
    return self.visibleViewController.shouldAutorotate;
}
// 支持的屏幕方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.visibleViewController.supportedInterfaceOrientations;
}

@end
