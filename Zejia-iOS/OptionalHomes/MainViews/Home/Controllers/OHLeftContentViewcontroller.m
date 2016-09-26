//
//  OHLeftContentViewcontroller.m
//  OptionalHome
//
//  Created by haili on 16/7/25.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHLeftContentViewcontroller.h"
#import "AppDelegate.h"
#import "OHLeftTableViewCell.h"
#import "OHLeftHeaderTableViewCell.h"

#import "OHMyAttentionsViewController.h"
#import "OHUserInfoViewController.h"
#import "OHSettingViewController.h"
#import "OHCommunityViewController.h"

#define FIRSTROWHEIGHT 192*kAdaptationCoefficient   //第一行的高度
#define ROWHEIGHT 66*kAdaptationCoefficient        //表的行高

@interface OHLeftContentViewcontroller () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _footerHeight;       //表footer的高度
    NSArray *_titleArr;          //标题数组
    NSArray *_titleImageArr;     //标题图片数组
}
@end

@implementation OHLeftContentViewcontroller

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}
- (void)viewDidLoad {
    self.isShowNaviView = NO;
    [super viewDidLoad];
    _titleArr = @[@"我的关注",@"个人中心",@"设置"];
    _titleImageArr = @[@"nev_collect_icon",@"nev_porfile_icon",@"nev_eidt_icon"];
    _footerHeight = OHScreenH-FIRSTROWHEIGHT-ROWHEIGHT*_titleArr.count;
    // Do any additional setup after loading the view.
    UITableView *tableview = [[UITableView alloc] init];
    tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview = tableview;
    tableview.scrollEnabled = NO;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
   
}

//搜索初始化
-(void)resetSearch{
    NSLog(@"搜索初始化");
    //跳转到社区特色页
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    OHCommunityViewController *communityVC = [[OHCommunityViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];
    [tempAppDelegate.mainNavigationController pushViewController:communityVC animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+_titleArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //返回的view
    UIView *footerView = [[UIView alloc] init];
    
    //分隔线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, 1.0)];
    lineLabel.backgroundColor = OHColor(238, 238, 238, 1.0);
    [footerView addSubview:lineLabel];
    
    //搜索初始化按钮
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake((OHScreenW-100-100*kAdaptationCoefficient)/2, _footerHeight-70*kAdaptationCoefficient, 100*kAdaptationCoefficient, 36*kAdaptationCoefficient);
    resetBtn.layer.cornerRadius = 4;
    resetBtn.layer.borderWidth = 1;
    resetBtn.layer.borderColor = OHColor(105, 49, 25, 1.0).CGColor;
    [resetBtn setTitleColor:OHColor(105, 49, 25, 1.0) forState:UIControlStateNormal];
    [resetBtn setTitle:@"搜索初始化" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    [footerView addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetSearch) forControlEvents:UIControlEventTouchUpInside];
    
    //提示语label
    CGFloat width = [OHCommon getLabelWidthWith:@"搜索结果不符合要求" and:12*kAdaptationCoefficient];
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake((OHScreenW-100-width)/2, CGRectGetMaxY(resetBtn.frame)+6*kAdaptationCoefficient, width, 16*kAdaptationCoefficient)];
    explainLabel.text = @"搜索结果不符合要求";
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
    explainLabel.textColor = OHColor(187, 187, 187, 1.0);
    [footerView addSubview:explainLabel];
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _footerHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        OHLeftHeaderTableViewCell *headCell = [[OHLeftHeaderTableViewCell alloc] init];
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [headCell setCellWith:kAvaterUrl andName:kNickName];
        return headCell;
    }
    else{
        static NSString *cellid = @"cellID";
        OHLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil){
            
            cell = [[OHLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setCellWithImage:_titleImageArr[indexPath.row-1] title:_titleArr[indexPath.row-1]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        NSLog(@"====个人中心");
        OHUserInfoViewController *userInfoVC = [[OHUserInfoViewController alloc] init];
        [tempAppDelegate.LeftSlideVC closeLeftView];
        [tempAppDelegate.mainNavigationController pushViewController:userInfoVC animated:YES];
    }
    else if (indexPath.row==1){
        NSLog(@"====我的关注");
        OHMyAttentionsViewController *myAttentionsVC = [[OHMyAttentionsViewController alloc] init];
        [tempAppDelegate.LeftSlideVC closeLeftView];
        [tempAppDelegate.mainNavigationController pushViewController:myAttentionsVC animated:YES];
    }
    else if (indexPath.row==2){
        NSLog(@"====个人中心");
        OHUserInfoViewController *userInfoVC = [[OHUserInfoViewController alloc] init];
        [tempAppDelegate.LeftSlideVC closeLeftView];
        [tempAppDelegate.mainNavigationController pushViewController:userInfoVC animated:YES];
    }
    else if (indexPath.row==3){
        NSLog(@"====设置");
        OHSettingViewController *settingVC = [[OHSettingViewController alloc] init];
        [tempAppDelegate.LeftSlideVC closeLeftView];
        [tempAppDelegate.mainNavigationController pushViewController:settingVC animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return FIRSTROWHEIGHT;
    }
    return ROWHEIGHT;
}


@end
