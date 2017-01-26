//
//  NewViewController.m
//  fddgd
//
//  Created by ZK on 2017/1/26.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "NewViewController.h"

typedef NS_ENUM(NSInteger){
    inlinexx,
    full

} dddddd;

@interface NewViewController (){
    IBOutlet UIView* palyaer;
    CGRect palyaerRect;
    dddddd ffffff;
}

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ffffff = inlinexx;
    // 旋转屏幕自动横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    palyaerRect=CGRectMake(0, 0, 414, 260);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//旋转屏幕
- (void)orientationDidChangeNotification:(NSNotification *)notification
{
    UIInterfaceOrientation curOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
//    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ){
//        palyaerRect=palyaer.frame;
//    }
    if (ffffff == inlinexx && UIInterfaceOrientationIsLandscape(curOrientation)) {
        CGRect oriFrame = [UIScreen mainScreen].bounds;

        [UIView animateWithDuration:0.3 animations:^{
            
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            
            //加上去的时候设frame
            palyaer.transform = CGAffineTransformMakeRotation(M_PI_2 );
            palyaer.frame =oriFrame;
            
            ffffff = full;
        }];

        
    }else if (ffffff == full && UIInterfaceOrientationIsPortrait(curOrientation)){
        [UIView animateWithDuration:0.3 animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            palyaer.transform = CGAffineTransformIdentity;
            
            palyaer.frame = palyaerRect;
            
            ffffff = inlinexx;
        }];


    }

}

-(BOOL)shouldAutorotate
{
    //还不能是 yes，如果yes，设方向不对了
    
        if (ffffff == full){
            return YES;
    
    
        }
    return NO;
}
// 支持的屏幕方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}




- (IBAction)xxxxx:(id)sender
{
//    ddddd* dd = [ddddd sha];
//    dd.xxxxxx = YES;
    
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ){
        palyaerRect=palyaer.frame;
    }
    
    CGRect oriFrame = [UIScreen mainScreen].bounds;

    [UIView animateWithDuration:0.3 animations:^{
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            palyaer.transform = CGAffineTransformIdentity;

            palyaer.frame = palyaerRect;

        }else{
            
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            
            //加上去的时候设frame
            palyaer.transform = CGAffineTransformMakeRotation(M_PI_2 );
            palyaer.frame =oriFrame;
            

        }
        
        
        
    } completion:^(BOOL finished) {

        
    }];
    

    
}

- (IBAction)bbback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
