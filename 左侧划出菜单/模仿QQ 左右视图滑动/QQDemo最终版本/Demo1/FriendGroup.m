//
//  FriendGroup.m
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "FriendGroup.h"
#import "Friend.h"

@implementation FriendGroup

+ (instancetype)friendGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];//此处调用下面的方法
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict]; //将字典里的值(组)设置上去
        
        NSMutableArray *tempArray = [NSMutableArray array];//用来记录每组里面的好友
        for (NSDictionary *dict in _friends) {
            
            Friend *friend = [Friend friendWithDict:dict];
            [tempArray addObject:friend];
        }
        _friends = tempArray;
    }
    return self;
}

@end
