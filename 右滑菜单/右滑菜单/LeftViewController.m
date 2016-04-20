//
//  LeftViewController.m
//  右滑菜单
//
//  Created by apple on 20/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import "LeftViewController.h"
#import "OtherViewController.h"
#import "AppDelegate.h"

#define  SectionH 150

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景图片
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftbackiamge"]];
    imageV.frame = self.view.bounds;
    [self.view addSubview:imageV];
    
    //创建表视图
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableV.dataSource = self;
    tableV.delegate = self;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableV];
}

#pragma mark
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifire = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"开通会员";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"QQ钱包";
    } else if (indexPath.row == 2) {
         cell.textLabel.text = @"个性装扮";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"我的收藏";
    } else if (indexPath.row == 4) {
         cell.textLabel.text = @"我的相册";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"我的文件";
    }

    return cell;
}


#pragma mark
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    OtherViewController *otherVC = [[OtherViewController alloc] init];
    //关闭左侧视图
    [appD.leftSlideVC closeLeftView];
    [appD.mainNavigationController pushViewController:otherVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, SectionH)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
