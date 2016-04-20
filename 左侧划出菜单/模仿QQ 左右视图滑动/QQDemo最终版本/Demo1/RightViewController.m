//
//  RightViewController.m
//  Demo1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 wxhl_zy16. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

//重写初始化方法
- (id)init
{
    self = [super init];
    if (self) {
        self.dataSource = @[@"One",@"Two",@"Three"];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
