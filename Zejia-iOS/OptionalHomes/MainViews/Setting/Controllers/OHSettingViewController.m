//
//  OHSettingViewController.m
//  OptionalHome
//
//  Created by lujun on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSettingViewController.h"
#import "OHSettingTableViewCell.h"
#import "OHSinaShareEditViewController.h"
#import "OHWebViewController.h"
#import "OHHomeViewController.h"

@interface OHSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *_settingTableView;                    //设置页tableview
}
@end

@implementation OHSettingViewController

- (void)viewDidLoad {
    
    self.titleStr = @"设置";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = OHColor(243, 243, 255, 1.0);
    
    //创建设置页TableView
    [self initSettingTableView];
}

//创建设置页TableView
- (void)initSettingTableView {
    
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH-kNaviHeight) style:UITableViewStyleGrouped];
    _settingTableView.backgroundColor = [UIColor clearColor];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _settingTableView.showsVerticalScrollIndicator = NO;
    //去掉tableview底部多余的分割线
    _settingTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_settingTableView];
}

#pragma mark - UITableViewDataSource 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
    }
    else if (section == 1) {
        
        return 2;
    }
    else if (section == 2) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid1 = @"cellID1";
    
    OHSettingTableViewCell *secttingCell = [tableView dequeueReusableCellWithIdentifier:cellid1];
    if (secttingCell == nil){
        
        secttingCell = [[OHSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
    }
    secttingCell.backgroundColor = [UIColor whiteColor];
    secttingCell.selectionStyle = UITableViewCellSelectionStyleNone;        //设置cell被选中时的类型
    
    //快速移除原有cell中的数据
    [secttingCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [secttingCell OHSettingTableViewCellConfigWithIndexPath:indexPath];

    return secttingCell;
}

#pragma mark - UITableViewDelegate 代理方法
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = OHColor(243, 243, 255, 1.0);
    
    return lineView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 12*kAdaptationCoefficient;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中第%ld个分区的第%ld行",(long)indexPath.section, (long)indexPath.row);
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {       //意见反馈
            
            [Singleton shareSingleton].sinaType = @"gotoShare";  //单例
            //跳转新浪微博分享编辑页面
            OHSinaShareEditViewController *sinaShareEditVC = [[OHSinaShareEditViewController alloc] init];
            sinaShareEditVC.shareContent = @"#时钟教室意见反馈##时钟教室|分时出租#http://wap.51shizhong.com/";
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weibo_link"]];
            sinaShareEditVC.shareImageView = imageView;
            [self.navigationController pushViewController:sinaShareEditVC animated:YES];
        }
        else if (indexPath.row == 1) {      //关于我们
        
            OHWebViewController *webVC = [[OHWebViewController alloc] initWithURL:[NSURL URLWithString:ABOUTMEURL] andTitle:@"关于我们"];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {           //给择家评分
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreURL]];
        }
        else if (indexPath.row == 1) {      //清除缓存
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            actionSheet.delegate = self;
            
            [actionSheet addButtonWithTitle:@"清空缓存"];
            [actionSheet addButtonWithTitle:@"取消"];
            actionSheet.cancelButtonIndex = 1;
            [actionSheet showInView:self.view];
        }
    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {        //退出登录
            
            [self userLogoutRequestWithSessionId:kSessionId];
        }
    }

    //行被选中后，自动变回反选状态的方法,此时deselect的代理方法不再被调用
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52*kAdaptationCoefficient;
}


//退出登录请求
- (void)userLogoutRequestWithSessionId:(NSString *)sessionId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"logoff" andDic:@{@"sessionId":sessionId} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            //退出登录成功时,数据统计
            [XXReporter userLogOut];
            
            //清空本地个人信息缓存数据，并回到首页
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SessionId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NickName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AvaterUrl"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"InHome"];
            
            if ([[[self.navigationController viewControllers] objectAtIndex:0] isKindOfClass:[OHHomeViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                OHHomeViewController *homeVC = [[OHHomeViewController alloc] init];
                [self.navigationController pushViewController:homeVC animated:YES];
            }
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UIActionSheetDelegate 代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        //清除缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        [_settingTableView reloadData];
    }
    else {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
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
