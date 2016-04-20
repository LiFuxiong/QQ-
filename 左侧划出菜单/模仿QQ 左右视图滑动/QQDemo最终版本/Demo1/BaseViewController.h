//
//  BaseViewController.h
//  Demo1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 wxhl_zy16. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end
