//
//  Friend.h
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic, copy) NSString *icon;             //好友图片的名字
@property (nonatomic, copy) NSString *intro;            //个性签名
@property (nonatomic, copy) NSString *name;             //好友备注名
@property (nonatomic, assign, getter = isVip) BOOL vip; //判断是不是VIP

+ (instancetype)friendWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
