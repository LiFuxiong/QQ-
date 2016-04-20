//
//  LeftSlideViewController.m
//  右滑菜单
//
//  Created by apple on 20/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import "LeftSlideViewController.h"

//屏幕宽度
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

//打开左侧窗时，中视图(右视图）缩放比例(建议0.6 - 1.0 之间)
#define MainScale   .8
//打开左侧窗时，中视图(右视图)露出的宽度
#define MainDistance   100

//打开左侧窗时，中视图中心点
#define MainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * MainScale / 2.0 - MainDistance, kScreenHeight / 2.0)

//动画时间
#define AnimationTime .35

//蒙版的透明度
#define  MatteViewOpaque .5

//左侧视图
#define LeftAlpha 0.9  //左侧蒙版的最大值
#define LeftCenterX 30 //左侧初始偏移量
#define LeftScale 0.7 //左侧初始缩放比例

//视图滑动速度
#define Speed 0.5


@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController *leftVC; //滑动的左主控制器
@property (strong, nonatomic) UIViewController *mainVC; //显示主控制器

@property (strong, nonatomic) UITableView *leftTableV; //左侧视图的表视图
@property (strong, nonatomic) UITapGestureRecognizer *tapMainVC; //主视图点击手势
@property (strong, nonatomic) UIView *matteView; //左侧视图的蒙版

@property (strong, nonatomic) UIPanGestureRecognizer *mainPan; //主视图滑动手势

@property (assign, nonatomic) CGFloat scalef; //横向位移距离

@end

@implementation LeftSlideViewController

/** 初始化侧滑控制器 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC andMainView:(UIViewController *)mainVC {
    self = [super init];
    if (self) {
        //将控制保留
        self.mainVC = mainVC;
        self.leftVC = leftVC;
        self.speedf = Speed;
        //将视图添加上去
        [self.view addSubview:self.leftVC.view];
        
        //给左侧视图添加一个蒙版
        self.matteView = [[UIView alloc] init];
        self.matteView.frame = self.leftVC.view.bounds;
        self.matteView.backgroundColor = [UIColor blackColor];
        self.matteView.alpha = MatteViewOpaque;
        
        //将左侧视图添加视图上
        [self.leftVC.view addSubview:self.matteView];
        [self addChildViewController:self.leftVC];
        
        //获取左侧视图上面的表视图
        for (UIView *subV in self.leftVC.view.subviews) {
            if ([subV isKindOfClass:[UITableView class]]) {
                self.leftTableV = (UITableView *)subV;
            }
        }
       
        //设置左侧视图里面表视图的大小
        self.leftTableV.frame = CGRectMake(0, 0, kScreenWidth - MainDistance, kScreenHeight);
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableV.transform = CGAffineTransformMakeScale(LeftScale, LeftScale);
        self.leftTableV.center = CGPointMake(LeftCenterX, kScreenHeight * 0.5);
        
        //给主视图添加一个滑动手势
        self.mainPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainPanAction:)];
        self.mainPan.delegate = self;
        [self.mainVC.view addGestureRecognizer:self.mainPan];
        
        //最后面添加主视图
        [self.view addSubview:self.mainVC.view];
        [self addChildViewController:self.mainVC];
        
        self.leftViewState = NO; //初始时左侧视图关闭状态
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



/** 打开左侧视图*/
- (void)openLeftView {
    //动画
    [UIView animateWithDuration:AnimationTime animations:^{
        //主视图动画
        self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, MainScale, MainScale);
        self.mainVC.view.center = MainPageCenter;
        self.matteView.alpha = 0;
        
        //设置左侧tableview的位置和缩放系数
        self.leftTableV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        self.leftTableV.center = CGPointMake((kScreenWidth - MainDistance) / 2.0, kScreenHeight / 2.0);
    }];
    
    self.leftViewState = YES;
    //给主视图添加一个点击事件
    [self addTapMainVC];
}

/**
 *  给主视图添加点击手势，点击关闭左侧视图
 */
- (void)addTapMainVC {
    if (!self.tapMainVC) {
        self.tapMainVC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftView)];
        self.tapMainVC.numberOfTapsRequired = 1;
    }
    [self.mainVC.view addGestureRecognizer:self.tapMainVC];
}



/** 关闭左侧视图*/
- (void)closeLeftView {
    //动画
    [UIView animateWithDuration:AnimationTime animations:^{
        //主视图动画
        self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        self.mainVC.view.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight / 2.0);
        self.matteView.alpha = MatteViewOpaque;
        
        //设置左侧tableview的位置和缩放系数
        self.leftTableV.transform = CGAffineTransformMakeScale(LeftScale, LeftScale);
        self.leftTableV.center = CGPointMake(LeftCenterX, kScreenHeight * 0.5);
    }];
    //移除添加在住视图上面的点击手势
    [self removeMainVCTap];
    self.leftViewState = NO;
}

/**
 *  移除添加在住视图上面的点击手势
 */
- (void)removeMainVCTap {
    if (self.tapMainVC) {
        [self.mainVC.view removeGestureRecognizer:self.tapMainVC];
        self.tapMainVC = nil;
    }
}



#pragma mark 
#pragma mark -- 主视图滑动手势事件
- (void)mainPanAction:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    self.scalef = point.x * self.speedf + self.scalef;
    
    //根据位置，判读视图是否还需移动
    BOOL needMoveMainVC = YES;
    CGFloat mainVC_X = self.mainVC.view.frame.origin.x;
    if (((mainVC_X <= 0) && (self.scalef <= 0)) ||((mainVC_X >= (kScreenWidth - MainDistance)) && (self.scalef > 0))) {
        //修改横位移
        self.scalef = 0.0;
        needMoveMainVC = NO;
    }
    
    //根据视图位置判断滑动方向
    CGFloat panView_X = pan.view.frame.origin.x;
    if(needMoveMainVC && (panView_X >= 0) && (panView_X <= (kScreenWidth - MainDistance))) {//右滑
        CGFloat panCenterX = pan.view.center.x + point.x * self.speedf;
        if (panCenterX < kScreenWidth *.5) {
            panCenterX = kScreenWidth *.5;
        }
        CGFloat panCenterY = pan.view.center.y;
        //设置中心点
        pan.view.center = CGPointMake(panCenterX, panCenterY);
        //缩放
        CGFloat scale = 1 - (1 - MainScale) * (panView_X / (kScreenWidth - MainDistance));
        pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        
        
        //左侧视图
        CGFloat leftTabCenterX = LeftCenterX + ((kScreenWidth - MainDistance) * 0.5 - LeftCenterX ) * (panView_X / (kScreenWidth - MainDistance));
        CGFloat leftScale = LeftScale + (1 - LeftScale) * (panView_X / (kScreenWidth - MainDistance)) ;
        self.leftTableV.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftTableV.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale, leftScale);
        
        //蒙版透明度
        CGFloat tempAlpha = MatteViewOpaque - MatteViewOpaque * (panView_X / (kScreenWidth - MatteViewOpaque));
        self.matteView.alpha = tempAlpha;
    } else {
        //超出范围
        if (mainVC_X < 0) {
            [self closeLeftView];
            self.scalef = 0.0;
        } else if (mainVC_X > kScreenWidth - MainDistance) {
            [self openLeftView];
            self.scalef = 0;
        }
    }
    
    //手势结束后修正位置，超过约一半时向多出的一半偏移
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat distance = (kScreenWidth - MainDistance) / 2.0 - 40;
        if (fabs(self.scalef) > distance) {
            if (self.leftViewState) {
                [self closeLeftView];
            } else {
                [self openLeftView];
            }
        } else {
            if (self.leftViewState) {
                [self openLeftView];
            } else {
                [self closeLeftView];
            }
        }
        self.scalef = 0.0;
        
    }
}


/** 设置滑动开关是否开启*/
- (void)setPanEnabled: (BOOL) enabled {
    [self.mainPan setEnabled:enabled];
}

#pragma mark
#pragma mark -- UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == 123){
        //        NSLog(@"不响应侧滑");
        return NO;
    } else {
        //        NSLog(@"响应侧滑");
        return YES;
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
