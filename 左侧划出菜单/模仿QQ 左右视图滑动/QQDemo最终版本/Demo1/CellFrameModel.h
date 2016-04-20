//
//  CellFrameModel.h
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>
@class MessageModel;

#define textPadding 15

@interface CellFrameModel : NSObject

@property (nonatomic, strong) MessageModel *message;     //创建一个信息对象

@property (nonatomic, assign, readonly) CGRect timeFrame;//时间的frame
@property (nonatomic, assign, readonly) CGRect iconFrame;//头像的Frame
@property (nonatomic, assign, readonly) CGRect textFrame;//内容的Frame
@property (nonatomic, assign, readonly) CGFloat cellHeght;//cell的高度

@end
