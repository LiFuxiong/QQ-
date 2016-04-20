//
//  ZSMMenuViewController.m
//  ZSMMenuViewContrller
//
//  Created by zsm on 14-10-7.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ZSMMenuViewController.h"
#define PUSH_SideWidth 50
#define PUSH_Duration .35
static ZSMMenuViewController *single = nil;

@interface ZSMMenuViewController ()

@property (strong, nonatomic) UIImageView *bgImageView; // 背景视图
@property (assign, nonatomic) CGPoint startPoint;
@end

@implementation ZSMMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 设计成单例
        single = self;
        
        // 初始化对象
        self.leftScale = .5;
        self.leftSideWidth = 160;
        self.rightScale = .5;
        self.rightSideWidth = 160;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 设计成单例
        single = self;
        
        // 初始化对象
        self.leftScale = .5;
        self.leftSideWidth = 160;
        self.rightScale = .5;
        self.rightSideWidth = 160;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 01.创建背景视图
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.backgroundColor = [UIColor blackColor];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 判断当前是否有背景视图
    if (self.backgroundImageName != nil) {
        self.bgImageView.image = [UIImage imageNamed:_backgroundImageName];
    }
    // 添加到最底层
    [self.view insertSubview:self.bgImageView atIndex:0];
    
    // 02.添加手势对象
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChanged:)];
    [self.view addGestureRecognizer:_pan];

}

#pragma mark - 写入背景图片名字的时候调用的方法
- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    if (_backgroundImageName != backgroundImageName) {
        _backgroundImageName = backgroundImageName;
        
        // 如果当前背景视图已经存在就设置
        if (_bgImageView != nil) {
            _bgImageView.image = [UIImage imageNamed:_backgroundImageName];
        }
    }
}


#pragma mark - 写入子视图控制器时调用的set方法
- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController != leftViewController) {
        // 如果左侧视图控制器的根视图已经添加到当前视图控制器的根视图上了我们就移除掉，arc会自动帮我们销毁该对象
        if (_leftViewController.view.superview != nil) {
            [_leftViewController.view removeFromSuperview];
        }
        _leftViewController = leftViewController;
        
        // 把左侧视图控制器的根视图添加到当前视图上
        if (_centerViewController != nil) {
            [self.view insertSubview:_leftViewController.view belowSubview:_centerViewController.view];
        } else {
            [self.view addSubview:_leftViewController.view];
        }
    }
}

- (void)setCenterViewController:(UIViewController *)centerViewController
{
    if (_centerViewController != centerViewController) {
        // 如果中心视图控制器的根视图已经添加到当前视图控制器的根视图上了我们就移除掉，arc会自动帮我们销毁该对象
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (_centerViewController.view.superview != nil) {
            // 记录上一次视图的位置
            transform = _centerViewController.view.transform;
            [_centerViewController.view removeFromSuperview];
        }
        _centerViewController = centerViewController;
        
        // 设置视图的位置
        _centerViewController.view.transform = transform;
        
        // 设置阴影效果
        [self centerViewSetShadow];
        
        // 把中心视图控制器的根视图添加到当前视图上
        [self.view addSubview:_centerViewController.view];
    }
}

// 设置阴影效果
- (void)centerViewSetShadow
{
    _centerViewController.view.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    _centerViewController.view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _centerViewController.view.layer.shadowOpacity = .5;//阴影透明度，默认0
    _centerViewController.view.layer.shadowRadius = 10;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = _centerViewController.view.bounds.size.width;
    float height = _centerViewController.view.bounds.size.height;
    float x = _centerViewController.view.bounds.origin.x;
    float y = _centerViewController.view.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = CGPointMake(x - addWH,y - addWH);
    CGPoint topRight     = CGPointMake(x + width + addWH ,y - addWH);
    
    
    CGPoint bottomRight  = CGPointMake(x + width + addWH ,y + height + addWH);

    CGPoint bottomLeft   = CGPointMake(x - addWH,y + height + addWH);
    
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addLineToPoint:topRight];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:topLeft];
    
    //设置阴影路径
    _centerViewController.view.layer.shadowPath = path.CGPath;
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController != rightViewController) {
        // 如果右侧视图控制器的根视图已经添加到当前视图控制器的根视图上了我们就移除掉，arc会自动帮我们销毁该对象
        if (_rightViewController.view.superview != nil) {
            [_rightViewController.view removeFromSuperview];
        }
        _rightViewController = rightViewController;
        
        // 把右侧视图控制器的根视图添加到当前是图上
        if (_centerViewController != nil) {
            [self.view insertSubview:_rightViewController.view belowSubview:_centerViewController.view];
        } else {
            [self.view addSubview:_rightViewController.view];
        }
    }
}

#pragma mark - 显示视图方法
// 显示左侧视图
- (void)showLeftViewController
{
    if (_leftViewController != nil) {
        
        // 当前视图控制器现实的状态
        if (self.menuside == ZSMMenuSideNone) {
            // 1.左侧视图插入到中间视图的后面
            if (_rightViewController.view.superview != nil) {
                [_rightViewController.view removeFromSuperview];
            }
            
            [self.view insertSubview:_leftViewController.view belowSubview:_centerViewController.view];
            
            // 2.左测视图动画（初始化效果）
            // 缩放
            CGAffineTransform z_transform_Scafe = CGAffineTransformMakeScale(_leftScale,_leftScale);
            // 平移
            CGAffineTransform z_transform_Translation = CGAffineTransformMakeTranslation(-_leftSideWidth * .5 , 0);
            // 组合
            CGAffineTransform z_transform = CGAffineTransformConcat(z_transform_Scafe, z_transform_Translation);
            _leftViewController.view.transform = z_transform;
            _leftViewController.view.alpha = 0;
            
            
            // 实现视图切换动画
            [UIView animateWithDuration:PUSH_Duration animations:^{
                // 1.中间视图动画效果
                // 缩放
                CGAffineTransform transform_Scafe = CGAffineTransformMakeScale(_leftScale, _leftScale);
                // 平移
                CGAffineTransform transform_Translation = CGAffineTransformMakeTranslation(_leftSideWidth, 0);
                // 组合
                CGAffineTransform transform = CGAffineTransformConcat(transform_Scafe, transform_Translation);
                _centerViewController.view.transform = transform;
                
                // 2.左侧视图动画效果
                _leftViewController.view.transform = CGAffineTransformIdentity;
                _leftViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
                self.menuside = ZSMMenuSideLeft;
            }];
        }
    }
}

+ (void)showLeftViewController
{
    [[self shareZSMMenuViewController] showLeftViewController];
}

// 显示右侧视图
- (void)showRightViewController
{
    if (_rightViewController != nil) {
        // 当前视图控制器现实的状态
        if (self.menuside == ZSMMenuSideNone) {
            // 右侧视图插入到中间视图的后面
            if (_leftViewController.view.superview != nil) {
                [_leftViewController.view removeFromSuperview];
            }
            [self.view insertSubview:_rightViewController.view belowSubview:_centerViewController.view];
            
            // 实现视图切换动画
            [UIView animateWithDuration:PUSH_Duration animations:^{
                // 缩放
                CGAffineTransform transform_Scafe = CGAffineTransformMakeScale(_rightScale, _rightScale);
                // 平移
                CGAffineTransform transform_Translation = CGAffineTransformMakeTranslation(-_rightSideWidth, 0);
                // 组合
                CGAffineTransform transform = CGAffineTransformConcat(transform_Scafe, transform_Translation);
                _centerViewController.view.transform = transform;
            } completion:^(BOOL finished) {
                self.menuside = ZSMMenuSideRight;
            }];
        }
    }
}

+ (void)showRightViewController
{
    [[self shareZSMMenuViewController] showRightViewController];
}

// 现实中间视图
- (void)showCenterViewController
{
    if (_centerViewController != nil) {
        // 当前视图控制器现实的状态
        if (self.menuside != ZSMMenuSideNone) {
        
            // 实现视图切换动画
            [UIView animateWithDuration:PUSH_Duration animations:^{
                // 1.恢复中间视图初始化状态
                _centerViewController.view.transform = CGAffineTransformIdentity;
                
                // 2.左测视图动画（初始化效果）
                // 缩放
                CGAffineTransform z_transform_Scafe = CGAffineTransformMakeScale(_leftScale,_leftScale);
                // 平移
                CGAffineTransform z_transform_Translation = CGAffineTransformMakeTranslation(-_leftSideWidth * .5 , 0);
                // 组合
                CGAffineTransform z_transform = CGAffineTransformConcat(z_transform_Scafe, z_transform_Translation);
                _leftViewController.view.transform = z_transform;
                _leftViewController.view.alpha = 0;

            } completion:^(BOOL finished) {
                self.menuside = ZSMMenuSideNone;
            }];
        }
    }
}

+ (void)showCenterViewController
{
    [[self shareZSMMenuViewController] showCenterViewController];
}

#pragma mark - 单例模式
// 获取当前对象
+ (instancetype)shareZSMMenuViewController
{
    if (single == nil) {
        @synchronized(self) {
            single = [[ZSMMenuViewController alloc] init];
        }
    }
    return single;
}

#pragma mark - 手势
- (void)panChanged:(UIPanGestureRecognizer *)pan
{
    // 获取手指对象
    CGPoint point = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 01.滑动开始
        _startPoint = point;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // 02.滑动改变

        [self showViewWithLenght:point.x - _startPoint.x animated:NO];

    } else if (pan.state == UIGestureRecognizerStateEnded ) {
        // 03.滑动结束或者被打断
        [self showViewWithLenght:point.x - _startPoint.x animated:YES];
    }
}

// 通过滑动的距离设置当前视图的位置
- (void)showViewWithLenght:(double)lenght animated:(BOOL)animated
{
    // 当前现实的宽度
    double width = 0;
    // 当前现实的比例
    double scale = 0;
    
    // 当前视图滑动位置
    if (self.menuside == ZSMMenuSideLeft) {
        // 当前视图只能向左滑动
        lenght = MIN(0, MAX(-_leftSideWidth, lenght));
        width = _leftSideWidth + lenght;
        scale = 1.0 - (1.0 - _leftScale) * (width / _leftSideWidth);
    } else if (self.menuside == ZSMMenuSideNone) {
        // 当前视图可以向左右滑动
        lenght = MIN(_leftSideWidth, MAX(-_rightSideWidth, lenght));
        width = lenght;
        // 向右滑动现实左侧视图的时候
        if (lenght >= 0) {
            if (_leftViewController == nil) {
                _centerViewController.view.transform = CGAffineTransformIdentity;
                return;
            } else {
                // 左侧视图插入到中间视图的后面
                if (_rightViewController != nil) {
                    // 右侧视图从父视图上移除
                    [_rightViewController.view removeFromSuperview];
                    [self.view insertSubview:_leftViewController.view belowSubview:_centerViewController.view];
                }
                
            }
            // 向右面滑动
            scale = 1.0 - (1.0 - _leftScale) * (ABS(width) / _leftSideWidth);
        } else {
            if (_rightViewController == nil) {
                _centerViewController.view.transform = CGAffineTransformIdentity;
                return;
            } else {
                // 右侧视图插入到中间视图的后面
                // 如果左侧视图不为空，左侧视图从俯视图上移除
                if (_leftViewController != nil) {
                    [_leftViewController.view removeFromSuperview];
                    [self.view insertSubview:_rightViewController.view belowSubview:_centerViewController.view];
                }
                
            }
            scale = 1.0 - (1.0 - _rightScale) * (ABS(width) / _rightSideWidth);
        }
    } else if (self.menuside == ZSMMenuSideRight) {
        NSLog(@"3---------------");
        // 当前视图只能向右侧滑动
        lenght = MIN(_rightSideWidth, MAX(0, lenght));
        width = lenght - _rightSideWidth;
        scale = 1.0 - (1.0 - _rightScale) * (-width / _rightSideWidth);

    }
    
    // 缩放
    CGAffineTransform transform_Scafe = CGAffineTransformMakeScale(scale, scale);
    // 平移
    CGAffineTransform transform_Translation = CGAffineTransformMakeTranslation(width, 0);
    // 组合
    CGAffineTransform transform = CGAffineTransformConcat(transform_Scafe, transform_Translation);
    _centerViewController.view.transform = transform;
    
    // 左测视图动画
    if (_leftViewController.view.superview != nil) {
        // 缩放 和中间控制器成反比
        CGAffineTransform z_transform_Scafe = CGAffineTransformMakeScale(1 - scale + _leftScale, 1 - scale + _leftScale);
        // 平移
        CGAffineTransform z_transform_Translation = CGAffineTransformMakeTranslation((ABS(width) -_leftSideWidth) * .5 , 0);
        // 组合
        CGAffineTransform z_transform = CGAffineTransformConcat(z_transform_Scafe, z_transform_Translation);
        _leftViewController.view.transform = z_transform;
        _leftViewController.view.alpha = ABS(width) / _leftSideWidth;
    }
    
    
    // 手指离开的时候需要有动画存在
    if (animated == YES) {
        // 禁用手势
        [self.pan setEnabled:NO];
        if ((self.menuside == ZSMMenuSideLeft && _leftSideWidth - width < _leftSideWidth * .3) || (self.menuside == ZSMMenuSideNone && width >= _leftSideWidth * .3)) {
            
            //动态判断动画时间
            NSTimeInterval duration = PUSH_Duration * (1.0 - width / _leftSideWidth);
            
            // 实现视图切换动画
            [UIView animateWithDuration:duration animations:^{
                // 1.中间视图动画
                // 缩放
                CGAffineTransform transform_Scafe = CGAffineTransformMakeScale(_leftScale, _leftScale);
                // 平移
                CGAffineTransform transform_Translation = CGAffineTransformMakeTranslation(_leftSideWidth, 0);
                // 组合
                CGAffineTransform transform = CGAffineTransformConcat(transform_Scafe, transform_Translation);
                _centerViewController.view.transform = transform;
                
                // 2.左测视图动画
                _leftViewController.view.transform = CGAffineTransformIdentity;
                _leftViewController.view.alpha = 1;
                
            } completion:^(BOOL finished) {
                self.menuside = ZSMMenuSideLeft;
                // 开启手势
                [self.pan setEnabled:YES];
            }];
        } else if ((self.menuside == ZSMMenuSideLeft && _leftSideWidth - width >= _leftSideWidth * .3) || (self.menuside == ZSMMenuSideNone && ABS(width) <= _leftSideWidth * .3 ) || (self.menuside == ZSMMenuSideRight && _rightSideWidth + width >= _rightSideWidth * .3 )) {
            // 显示中间视图
            // 动态判断动画时间
            NSTimeInterval duration = PUSH_Duration * (1.0 - width / _leftSideWidth);
            if (width < 0) {
                duration = PUSH_Duration * (ABS(width) / _rightSideWidth);
            }
            
            // 实现视图切换动画
            [UIView animateWithDuration:duration animations:^{
                // 1.中间视图动画
                _centerViewController.view.transform = CGAffineTransformIdentity;
                
                // 2.左测视图动画(隐藏效果)
                // 缩放
                CGAffineTransform z_transform_Scafe = CGAffineTransformMakeScale(_leftScale,_leftScale);
                // 平移
                CGAffineTransform z_transform_Translation = CGAffineTransformMakeTranslation(-_leftSideWidth * .5 , 0);
                // 组合
                CGAffineTransform z_transform = CGAffineTransformConcat(z_transform_Scafe, z_transform_Translation);
                _leftViewController.view.transform = z_transform;
                _leftViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                self.menuside = ZSMMenuSideNone;
                // 开启手势
                [self.pan setEnabled:YES];
            }];
        } else if ((self.menuside == ZSMMenuSideRight && _rightSideWidth + width < _rightSideWidth * .3) || (self.menuside == ZSMMenuSideNone && width <= -_leftSideWidth * .3)) {
            //动态判断动画时间
            NSTimeInterval duration = PUSH_Duration * (1.0 - ABS(width) / _rightSideWidth);
            
            // 实现视图切换动画
            [UIView animateWithDuration:duration animations:^{
                // 缩放
                CGAffineTransform transform_Scafe = CGAffineTransformMakeScale(_rightScale, _rightScale);
                // 平移
                CGAffineTransform transform_Translation = CGAffineTransformMakeTranslation(-_rightSideWidth, 0);
                // 组合
                CGAffineTransform transform = CGAffineTransformConcat(transform_Scafe, transform_Translation);
                _centerViewController.view.transform = transform;
            } completion:^(BOOL finished) {
                self.menuside = ZSMMenuSideRight;
                // 开启手势
                [self.pan setEnabled:YES];
            }];
        }
    }
}

#pragma mark - 切换中间视图控制器
// 切换中间控制器视图
- (void)exChangedCenterViewController:(UIViewController *)centerViewController showCenterViewController:(BOOL)show
{
    self.centerViewController = centerViewController;
    
    if (show == YES) {
        [self showCenterViewController];
    }
}


@end
