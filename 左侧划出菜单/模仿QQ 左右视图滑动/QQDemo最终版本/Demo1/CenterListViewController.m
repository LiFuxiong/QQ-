//
//  CenterListViewController.m
//  Demo1
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 wxhl_zy16. All rights reserved.
//

#import "CenterListViewController.h"
#import "FriendGroup.h"
#import "Friend.h"
#import "HeadView.h"
#import "CenterViewController.h"

@interface CenterListViewController () <HeadViewDelegate>
{
    NSArray *_friendsData; //存放数据
}

@end

@implementation CenterListViewController

//单例创建对象
+ (CenterListViewController *)shareCenterViewController
{
    static CenterListViewController *centerListViewController = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建
        centerListViewController = [[CenterListViewController alloc] init];
        
    });
    
    return centerListViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置标题
    self.title = @"好友列表";
    //设置表视图头视图的高度
    self.tableView.sectionHeaderHeight = 40;
    //设置视图的背景颜色
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cen_bg.png"]];
    
    //将表视图添加到视图上面
    [self.view addSubview:self.tableView];
    //添加数据
    [self loadData];
}

#pragma mark 加载数据
- (void)loadData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"friends.plist" withExtension:nil];
    NSArray *tempArray = [NSArray arrayWithContentsOfURL:url];
    
    NSMutableArray *fgArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        FriendGroup *friendGroup = [FriendGroup friendGroupWithDict:dict];
        [fgArray addObject:friendGroup];
    }
    
    _friendsData = fgArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _friendsData.count;  //好友组数
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroup *friendGroup = _friendsData[section];
    NSInteger count = friendGroup.isOpened ? friendGroup.friends.count : 0;//判断组是否是展开,如果是就返回每组中好友的个数,否则返回0
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FriendGroup *friendGroup = _friendsData[indexPath.section];
    Friend *friend = friendGroup.friends[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:friend.icon];
    cell.textLabel.textColor = friend.isVip ? [UIColor redColor] : [UIColor blackColor];    //判断好友是不是VIP,如果是VIP字体就设置为红色,否之为黑色
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.intro;   //设置好友的个性签名
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];

    headView.delegate = self;   //设置代理对象
    headView.friendGroup = _friendsData[section];   //赋值
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建对话视图控制器
    CenterViewController *viewController = [[CenterViewController alloc] init];

    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - 实现头视图的代理协议方法
- (void)clickHeadView
{
    //刷新表视图
    [self.tableView reloadData];
}

@end
