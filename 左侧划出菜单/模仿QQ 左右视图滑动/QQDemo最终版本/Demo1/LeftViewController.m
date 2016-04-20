//
//  LeftViewController.m
//  Demo1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 wxhl_zy16. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)init {
    self = [super init];
    if (self) {
        
        [self setDataSource:@[@"你好One", @"你好Two", @"你好Three", @"视图四", @"视图五"]];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.origin.y = 95;
    tableViewFrame.size.height = 377;
    self.tableView.frame = tableViewFrame;
    
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableViewDataSource
//重写父类的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;

}



@end
