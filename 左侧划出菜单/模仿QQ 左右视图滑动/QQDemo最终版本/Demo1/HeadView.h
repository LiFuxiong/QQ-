//
//  HeadView.h
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
@class FriendGroup;

//创建一个协议
@protocol HeadViewDelegate <NSObject>

@optional
- (void)clickHeadView;

@end

@interface HeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) FriendGroup *friendGroup;         //好友组

@property (nonatomic, weak) id<HeadViewDelegate> delegate;      //代理

+ (instancetype)headViewWithTableView:(UITableView *)tableView;

@end
