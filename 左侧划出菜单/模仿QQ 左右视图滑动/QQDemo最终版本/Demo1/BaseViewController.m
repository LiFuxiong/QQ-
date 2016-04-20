//
//  BaseViewController.m
//  Demo1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 wxhl_zy16. All rights reserved.
//

#import "BaseViewController.h"
#import "CenterViewController.h"
#import "DetailViewController.h"
#import "CenterListViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)init {
    self = [super init];
    if (self) {
        
        [self setDataSource:@[@"视图一", @"视图二", @"视图三", @"视图四", @"视图五"]];
    }
    return self;
}

//单例
- (UITableView *)tableView {
    //如果表视图为nil时
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    //**********
    //创建导航按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Left", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(left)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Right", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(right)];
    
    
}

#pragma mark - 导航按钮的点击事件
- (void)left {
    //*********************************************    
    CenterListViewController *centerViewController = [CenterListViewController shareCenterViewController];
    
    self.drawerController.centerViewController = [[UINavigationController alloc] initWithRootViewController:centerViewController];

    
    [self.drawerController toggleDrawerSide:XHDrawerSideLeft animated:YES completion:NULL];
    
}

- (void)right {
    
    CenterListViewController *centerViewController = [CenterListViewController shareCenterViewController];
    
    self.drawerController.centerViewController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    
    [self.drawerController toggleDrawerSide:XHDrawerSideRight animated:YES completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消单元格的选中,但不带动画
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [[cell textLabel] setText:[self dataSource][[indexPath row]]];
    [cell setSelectedBackgroundView:[UIView new]];
    [[cell textLabel] setHighlightedTextColor:[UIColor purpleColor]];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消单元格的选中,但是带有动画
    
    
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    //设置中间视图控制器的标题
    [[detailViewController navigationItem] setTitle:[self dataSource][[indexPath row]]];
    
    //小测试--------------------
    //改变图片
    if (indexPath.row == 0) {
        detailViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"3.jpg"]];
    } else if (indexPath.row == 1) {
        detailViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"6.jpg"]];
    } else if (indexPath.row == 2) {
        detailViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4.jpg"]];
    } else if (indexPath.row == 3) {
        detailViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"11.jpg"]];
    } else if (indexPath.row == 4) {
        detailViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"14.jpg"]];
    }
    
    //创建一个详情视图控制器的导航控制器
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    self.drawerController.centerViewController = navigationController;
    
    //点击单元格后回到中间视图
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

@end
