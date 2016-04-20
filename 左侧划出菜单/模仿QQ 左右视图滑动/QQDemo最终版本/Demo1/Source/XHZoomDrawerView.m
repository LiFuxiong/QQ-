//
//  XHZoomDrawerView.m
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "XHZoomDrawerView.h"
#import "XHDrawerControllerHeader.h"

@implementation XHZoomDrawerView

#pragma mark - UIView Overrides

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.scrollsToTop = NO;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake((CGRectGetWidth(frame) + XHContentContainerViewOriginX * 2), CGRectGetHeight(frame));
        
        // 左边
        _leftContainerView = [[UIView alloc] initWithFrame:self.bounds];
        
        // 中间内容
        _contentContainerView = [[UIView alloc] initWithFrame:self.bounds];
        
        
        xh_UIViewSetFrameOriginX(self.contentContainerView, XHContentContainerViewOriginX);
        
        // 右边
        _rightContainerView = [[UIView alloc] initWithFrame:self.bounds];
        
#warning 问题1
        xh_UIViewSetFrameOriginX(self.rightContainerView, CGRectGetWidth(self.contentContainerView.frame) + XHContentContainerViewOriginX);
        
        
        [self.scrollView setContentOffset:CGPointMake(XHContentContainerViewOriginX, 0.0f) animated:NO];
        
        //将三个视图添加都在滑动视图上面
        [self.scrollView addSubview:self.leftContainerView];
        [self.scrollView addSubview:self.rightContainerView];
        [self.scrollView addSubview:self.contentContainerView];
        [self addSubview:self.scrollView];
    }
    return self;
}
//*****************
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];

}


@end
