//
//  HeadView.m
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "HeadView.h"
#import "FriendGroup.h"

@interface HeadView()
{
    UIButton *_bgButton;
    UILabel *_numLabel;
}
@end

@implementation HeadView

+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"header";
    
    //头视图复用
    HeadView *headView = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[HeadView alloc] initWithReuseIdentifier:headIdentifier];
    }
    
    return headView;
}

//初始化方法
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgButton setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        [bgButton setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        [bgButton setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgButton.imageView.contentMode = UIViewContentModeCenter;
        bgButton.imageView.clipsToBounds = NO;
        bgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        _bgButton = bgButton;
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:numLabel];
        _numLabel = numLabel;
    }
    return self;
}

- (void)headBtnClick
{
    
    _friendGroup.opened = !_friendGroup.isOpened;//状态取反
    if ([_delegate respondsToSelector:@selector(clickHeadView)]) {
        
        //调用代理方法
        [_delegate clickHeadView];
    }
}

- (void)setFriendGroup:(FriendGroup *)friendGroup
{
    _friendGroup = friendGroup;
    
    [_bgButton setTitle:friendGroup.name forState:UIControlStateNormal];
    _numLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)friendGroup.online, (unsigned long)friendGroup.friends.count];
}
//此方法是父视图进行操作菜单时候都会调用的一个方法，而且是多次调用
- (void)didMoveToSuperview
{
    _bgButton.imageView.transform = _friendGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame = self.bounds;
    _numLabel.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
}












@end
