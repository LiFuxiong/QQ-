//
//  XHDrawerController.h
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import <UIKit/UIKit.h>

//创建一个枚举结构
typedef NS_ENUM(NSInteger, XHDrawerSide){
    XHDrawerSideNone = 0,
    XHDrawerSideLeft,//向左滑动
    XHDrawerSideRight,//向右滑动
};


@interface XHDrawerController : UIViewController

@property (nonatomic, assign, readonly) XHDrawerSide openSide;
@property (nonatomic, assign) CGFloat animateDuration;
@property (nonatomic, assign) CGFloat animationDampingDuration;
@property (nonatomic, assign) CGFloat animationVelocity;
@property (nonatomic, strong) UIViewController *centerViewController;//中间视图控制器
@property (nonatomic, strong) UIViewController *leftViewController;//左边视图控制器
@property (nonatomic, strong) UIViewController *rightViewController;//右边视图控制器
//@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign, getter = isSpringAnimationOn) BOOL springAnimationOn; //是否可以设置视图左右滑动时的弹性效果

- (void)toggleDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

- (void)closeDrawerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

- (void)openDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

@end

//为UIViewController添加一个类目
@interface UIViewController (XHDrawerController)

//设置属性
@property (nonatomic, readonly) XHDrawerController *drawerController;

@end


/*
 
 <IOS面试题库>
 1.写一个标准的宏min，而此宏输入两个参数返回一个较小的
 2.#import和#include有什么区别，<>和“”有什么区别
 3.属性@property里面的属性(readonly,retain,assign等等)的作用,应用在什么场合
 4.写一个委托的interface
 5.创建线程的方法是什么
 6.类别有什么作用
 7.写出方法获取IOS内存使用的情况
 8.在已越狱设置中IOS如何强制信息通知
 9.layer(层)与UIView的区别
 10.公共的、私有的、受保护的
 11.线程跟进程的区别
 12.OC的内存管理
 13.UIViewController的loadView loadDidView DidLoadView方法什么时候调用
 14.继承和类别在实现中有何区别，类别和类扩展的区别
 
 */






