//
//  AViewController.m
//  fddgd
//
//  Created by ZK on 2017/1/26.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "AViewController.h"
#import "ddddd.h"
#import "NewViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)xxxxx:(id)sender
{
    NewViewController* new = [[NewViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;

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
