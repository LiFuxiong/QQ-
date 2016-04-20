//
//  AppDelegate.h
//  右滑菜单
//
//  Created by apple on 20/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *leftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;

@end

