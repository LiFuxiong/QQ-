//
//  LeftSlideViewController.h
//  右滑菜单
//
//  Created by apple on 20/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSlideViewController : UIViewController

//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (nonatomic, assign) CGFloat speedf;

@property (assign, nonatomic) BOOL leftViewState; //左侧视图状态

/**
  初始化侧滑控制器
 @param leftVC 右视图控制器
 mainVC 中间视图控制器
 @result  初始化生成的对象
 */

- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC;


/**
 *  打开左侧视图
 */
- (void)openLeftView;



/**
 *  关闭左侧视图
 */
- (void)closeLeftView;



/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled;


@end
