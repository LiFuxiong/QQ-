//
//  XHDrawerController.m
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "XHDrawerController.h"
#import "XHZoomDrawerView.h"
#import "XHDrawerControllerHeader.h"

#import <objc/runtime.h>

static const CGFloat XHAnimateDuration = 0.3f;
static const CGFloat XHAnimationDampingDuration = 0.5f;
static const CGFloat XHAnimationVelocity = 20.0f;//切换视图时候的加速度

const char *XHDrawerControllerKey = "XHDrawerControllerKey";

//typedef enum ScrollDirection {
//    ScrollDirectionNone,
//    ScrollDirectionRight,
//    ScrollDirectionLeft,
//    ScrollDirectionUp,
//    ScrollDirectionDown,
//    ScrollDirectionCrazy,
//} ScrollDirection;

//为UIViewController添加一个类目
@implementation UIViewController (XHDrawerController)

//获取属性
- (XHDrawerController *)drawerController {
    //添加一个属性
    XHDrawerController *panDrawerController = objc_getAssociatedObject(self, &XHDrawerControllerKey);
    if (!panDrawerController) {
        panDrawerController = self.parentViewController.drawerController;
    }
    
    return panDrawerController;
}
//设置属性
- (void)setDrawerController:(XHDrawerController *)drawerController {
    
    //创建一个属性
    objc_setAssociatedObject(self, &XHDrawerControllerKey, drawerController, OBJC_ASSOCIATION_ASSIGN);
    
}

@end


@interface XHDrawerController () <UIScrollViewDelegate>
@property (nonatomic, assign, readwrite) XHDrawerSide openSide;//设置XHDrawerSide类型的状态（中、左、右）

@property (nonatomic, strong) XHZoomDrawerView *zoomDrawerView;//创建XHZoomDrawerView视图

@property (nonatomic, readonly) UIScrollView *scrollView;//创建一个滑动视图

@property (nonatomic, assign) NSInteger cuurrentContentOffsetX;
@end

@implementation XHDrawerController

#pragma mark - UIViewController Overrides

- (void)_setup {
    self.animateDuration = XHAnimateDuration;
    self.animationDampingDuration = XHAnimationDampingDuration;
    self.animationVelocity = XHAnimationVelocity;
    self.openSide = XHDrawerSideNone;//默认左右视图是关闭的状态
}

- (id)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

//设置视图位置大小
- (void)loadView {
    _zoomDrawerView = [[XHZoomDrawerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //设置autosizing
    self.zoomDrawerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth; //简单的调整位置
    
    self.zoomDrawerView.autoresizesSubviews = YES;//默认yes,如果self.bounds变化后，根据设置的autoresizingMask去调整大小
    
    //将视图添加到根视图上面
    self.view = self.zoomDrawerView;
    
}

- (void)viewDidLoad {
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    self.zoomDrawerView.scrollView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Open/Close methods

//点击左右导航按钮时调用了此方法
- (void)toggleDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    //**************???****************
//    NSParameterAssert(drawerSide != XHDrawerSideNone);
    if(self.openSide == XHDrawerSideNone){
        //如原状态是关闭,则就打开
        [self openDrawerSide:drawerSide animated:animated completion:completion];
    } else {
        //如原来状态是打开的,则关闭
        if((drawerSide == XHDrawerSideLeft &&
            self.openSide == XHDrawerSideLeft) ||
           (drawerSide == XHDrawerSideRight &&
            self.openSide == XHDrawerSideRight)){
               
               [self closeDrawerAnimated:animated completion:completion];
           }
        else if(completion) {
            //回调
            completion(NO);
        }
    }
}

- (void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self closeDrawerAnimated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

- (void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
    
    CGFloat damping = [self isSpringAnimationOn] ? 0.7f : 1.0f;//控制左右切换的弹性效果(<1弹性效果大,>=1后无弹性效果)
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.scrollView setContentOffset:CGPointMake(XHContentContainerViewOriginX, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            self.openSide = XHDrawerSideNone;

            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
            [self.scrollView setContentOffset:CGPointMake(XHContentContainerViewOriginX, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            self.openSide = XHDrawerSideNone;

            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)openDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    NSParameterAssert(drawerSide != XHDrawerSideNone);
    
    [self openDrawerSide:drawerSide animated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

- (void)openDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
    NSParameterAssert(drawerSide != XHDrawerSideNone);
    self.openSide = drawerSide;
#warning 可修改弹性效果
    CGFloat damping = [self isSpringAnimationOn] ? 0.7f : 1.0f;//控制左右切换的弹性效果(<1弹性效果大,>=1后无弹性效果)
    
    //如果当前IOS为7.0系统
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        //***7.0系统调用的方法***
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            if (drawerSide == XHDrawerSideLeft) {
                [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
                
            } else if (drawerSide == XHDrawerSideRight) {
                [self.scrollView setContentOffset:CGPointMake(2 * XHContentContainerViewOriginX, 0.0f) animated:NO];
            }
        } completion:^(BOOL finished) {
            self.openSide = drawerSide;
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [UIView animateWithDuration:0.35 delay:0 options:options animations:^{
            if (drawerSide == XHDrawerSideLeft) {
                [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            } else if (drawerSide == XHDrawerSideRight) {
//                [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) + XHContentContainerViewOriginX, 0.0f) animated:NO];
                
                [self.scrollView setContentOffset:CGPointMake(2 * XHContentContainerViewOriginX, 0.0f) animated:NO];
            }
            
        } completion:^(BOOL finished) {
            self.openSide = drawerSide;
            if (completion) {
                completion(finished);
            }
        }];
    }
    
}

#pragma mark - 滑动视图、中间视图、左边视图、右边视图的setter和getter方法

//属性:滑动视图 的getter方法
- (UIScrollView *)scrollView {
    return self.zoomDrawerView.scrollView;
}

//中间控制器的setter方法
- (void)setCenterViewController:(UIViewController *)centerViewController {
    if (![self isViewLoaded]) {
        [self view];
    }
    
    UIViewController *currentContentViewController =self.centerViewController;  //原来的
    _centerViewController = centerViewController;//传进来的
    
    UIView *contentContainerView = self.zoomDrawerView.contentContainerView;
    
    CGAffineTransform currentTransform = [contentContainerView transform]; //记录contentContainerView的transform
    [contentContainerView setTransform:CGAffineTransformIdentity];
    
    [self replaceController:currentContentViewController
              newController:self.centerViewController
                  container:self.zoomDrawerView.contentContainerView];
    
    [contentContainerView setTransform:currentTransform];   //重新设定transform
    //---------------------
    [self.zoomDrawerView setNeedsLayout];
}

//左边视图控制器的setter方法
- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (![self isViewLoaded]) {
        [self view];//调用loadView
    }
    UIViewController *currentLeftViewController = self.leftViewController;
    _leftViewController = leftViewController;
    [self replaceController:currentLeftViewController
              newController:self.leftViewController
                  container:self.zoomDrawerView.leftContainerView];
}

//右边视图控制器的setter方法
- (void)setRightViewController:(UIViewController *)rightViewController {
    if (![self isViewLoaded]) {
        [self view];
    }
    UIViewController *currentLeftViewController = self.rightViewController;
    _rightViewController = rightViewController;
    [self replaceController:currentLeftViewController
              newController:self.rightViewController
                  container:self.zoomDrawerView.rightContainerView];
}


#pragma mark - Instance Methods

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController container:(UIView *)container
{
    //如果视图不为空
    if (newController) {
        [self addChildViewController:newController];//???添加一个子视图控制器newController
        [[newController view] setFrame:[container bounds]];//设置newController的视图的大小(即此处将newController与XHZoomDrawerView类中的视图大小联系到一起了，如要改变newController视图的大小可通过XHZoomDrawerView类中的视图大小来改变)
        
        [newController setDrawerController:self];//调用视图控制器类目中一个扩展属性的setter方法,将自身传过去
        
        if (oldController) {
            //从原来的视图控制器过渡到新的视图控制器
            [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:0 animations:nil completion:^(BOOL finished) {
                
                [newController didMoveToParentViewController:self];
                
                [oldController willMoveToParentViewController:nil];
                [oldController removeFromParentViewController];
                [oldController setDrawerController:nil];
                
            }];
        } else {
            [container addSubview:[newController view]];
            [newController didMoveToParentViewController:self];//????
        }
    } else {
        [[oldController view] removeFromSuperview];
        [oldController willMoveToParentViewController:nil];
        [oldController removeFromParentViewController];
        [oldController setDrawerController:nil];
    }
}

#pragma mark - UIScrollViewDelegate Methods

//滑动视图实时监听的方法(在这里设置滑动视图滑动时带缩放功能)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //记录滑动视图此时的偏移量
    CGPoint contentOffset = [scrollView contentOffset];
    
    CGFloat contentOffsetX = 0.0;
    if (self.openSide == XHDrawerSideRight) {
        
        //设置缩放比例-----1
        contentOffsetX = XHContentContainerViewOriginX * 2 - contentOffset.x;
    } else if (self.openSide == XHDrawerSideLeft) {
        
        contentOffsetX = contentOffset.x;
    }
    
    //设置中间视图的缩放比例-----2
    CGFloat contentContainerScale = powf((contentOffsetX + XHContentContainerViewOriginX) / (XHContentContainerViewOriginX * 2.0f), .5f);//例如:pow(double x,double y)->表示x的y次幂

    CGAffineTransform contentContainerViewTransform = CGAffineTransformMakeScale(contentContainerScale, contentContainerScale);// 设置中间视图缩放的比例------3
    CGAffineTransform leftContainerViewTransform = CGAffineTransformMakeTranslation(contentOffsetX / 1.5f, 0.0f);
    
    CGAffineTransform rightContainerViewTransform = CGAffineTransformMakeTranslation(contentOffsetX / -1.5f, 0.0f);
    
    self.zoomDrawerView.contentContainerView.transform = contentContainerViewTransform;//设置中间视图缩的比例-----4
    
    self.zoomDrawerView.leftContainerView.transform = leftContainerViewTransform;
    self.zoomDrawerView.leftContainerView.alpha = 1 - contentOffsetX / XHContentContainerViewOriginX;
    
    self.zoomDrawerView.rightContainerView.transform = rightContainerViewTransform;
    self.zoomDrawerView.rightContainerView.alpha = 1 - contentOffsetX / XHContentContainerViewOriginX;
    
    if (self.openSide == XHDrawerSideLeft) {
        static BOOL leftContentViewControllerVisible = NO;
        if (contentOffsetX >= XHContentContainerViewOriginX) {
            if (leftContentViewControllerVisible) {
                [self.leftViewController beginAppearanceTransition:NO animated:YES];
                [self.leftViewController endAppearanceTransition];
                leftContentViewControllerVisible = NO;
                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                    [self setNeedsStatusBarAppearanceUpdate];
            }
        } else if (contentOffsetX < XHContentContainerViewOriginX && !leftContentViewControllerVisible) {
            [self.leftViewController beginAppearanceTransition:YES animated:YES];
            leftContentViewControllerVisible = YES;
            [self.leftViewController endAppearanceTransition];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                [self setNeedsStatusBarAppearanceUpdate];
        }
    } else if (self.openSide == XHDrawerSideRight) {
        static BOOL rightContentViewControllerVisible = NO;
        if (contentOffsetX >= XHContentContainerViewOriginX) {
            if (rightContentViewControllerVisible) {
                [self.rightViewController beginAppearanceTransition:NO animated:YES];
                [self.rightViewController endAppearanceTransition];
                rightContentViewControllerVisible = NO;
                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                    [self setNeedsStatusBarAppearanceUpdate];
            }
        } else if (contentOffsetX < XHContentContainerViewOriginX && !rightContentViewControllerVisible) {
            [self.rightViewController beginAppearanceTransition:YES animated:YES];
            rightContentViewControllerVisible = YES;
            [self.rightViewController endAppearanceTransition];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat targetContentOffsetX = targetContentOffset->x;
    CGFloat drawerPadding = XHContentContainerViewOriginX * 2 / 3.;
    if ((targetContentOffsetX >= drawerPadding && targetContentOffsetX < XHContentContainerViewOriginX && self.openSide == XHDrawerSideLeft) || (targetContentOffsetX > XHContentContainerViewOriginX && targetContentOffsetX <= (XHContentContainerViewOriginX * 2 - drawerPadding) && self.openSide == XHDrawerSideRight)) {
        
        targetContentOffset->x = XHContentContainerViewOriginX;
        
    } else if ((targetContentOffsetX >= 0 && targetContentOffsetX <= drawerPadding && self.openSide == XHDrawerSideLeft)) {
        
        targetContentOffset->x = 0.0f;
        self.openSide = XHDrawerSideLeft;
        
    } else if ((targetContentOffsetX > (XHContentContainerViewOriginX * 2 - drawerPadding) && targetContentOffsetX <= (XHContentContainerViewOriginX * 2) && self.openSide == XHDrawerSideRight)) {
        
        targetContentOffset->x = XHContentContainerViewOriginX * 2;
        self.openSide = XHDrawerSideRight;
    }
}

//**********7.0的方法
/*
- (UIViewController *)childViewControllerForStatusBarStyle {
    
    UIViewController *viewController;
    
    //self.scrollView 是调用上面的scrollView方法
    //根据偏移量判断当前是哪个视图控制器
    if (self.scrollView.contentOffset.x < XHContentContainerViewOriginX) {
        viewController = self.leftViewController;
    } else if (self.scrollView.contentOffset.x > XHContentContainerViewOriginX) {
        viewController = self.rightViewController;
    } else {
        viewController = self.centerViewController;
    }
    return viewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *viewController;
    if (self.scrollView.contentOffset.x < XHContentContainerViewOriginX) {
        viewController = self.leftViewController;
    } else if (self.scrollView.contentOffset.x > XHContentContainerViewOriginX) {
        viewController = self.rightViewController;
    } else {
        viewController = self.centerViewController;
    }
    return viewController;
}
*/
@end
