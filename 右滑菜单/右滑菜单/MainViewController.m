//
//  MainViewController.m
//  右滑菜单
//
//  Created by apple on 20/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建导航栏左侧按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 17, 14);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftNavBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}


#pragma mark
#pragma mark - leftNavBarBtnAction
- (void)leftNavBarBtnAction:(UIButton *)btn {
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appD.leftSlideVC.leftViewState) {
        [appD.leftSlideVC openLeftView];
    } else {
        [appD.leftSlideVC closeLeftView];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
