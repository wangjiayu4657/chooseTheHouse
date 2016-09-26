//
//  OHMyAttentionsViewController.m
//  OptionalHome
//
//  Created by lujun on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHMyAttentionsViewController.h"
#import "OHMyAttentionsTableViewCell.h"
#import "OHDetailViewController.h"

#import "OHMyAttentionsModel.h"

@interface OHMyAttentionsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myAttentionsTableView;        //我的关注页tableview
    
    NSMutableArray *_myAttentionsArray;         //我的关注数据源
}
@end

@implementation OHMyAttentionsViewController

- (void)viewDidLoad {
    self.titleStr = @"我的关注";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myAttentionsArray = [[NSMutableArray alloc] init];
    
    //我的关注请求
    NSLog(@"kSessionIdkSessionId_attention=%@",kSessionId);
    [self myAttentionsListRequestWithSessionId:kSessionId];
}

//我的关注请求
- (void)myAttentionsListRequestWithSessionId:(NSString *)sessionId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"getFollowList" andDic:@{@"sessionId":sessionId} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            if ([[dic objectForKey:@"response"] objectForKey:@"dataList"] != [NSNull null]) {
                for (NSDictionary *listDic in [[dic objectForKey:@"response"] objectForKey:@"dataList"]) {
                    OHMyAttentionsModel *myAttentionsModel = [OHMyAttentionsModel mj_objectWithKeyValues:listDic];
                    [_myAttentionsArray addObject:myAttentionsModel];
                }
                
                //创建我的关注页TableView
                [self initMyAttentionsTableView];
            }
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        [_myAttentionsTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//创建设置页TableView
- (void)initMyAttentionsTableView {
    
    if (_myAttentionsTableView == nil) {
        _myAttentionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH-kNaviHeight) style:UITableViewStylePlain];
        _myAttentionsTableView.backgroundColor = [UIColor clearColor];
        _myAttentionsTableView.delegate = self;
        _myAttentionsTableView.dataSource = self;
        _myAttentionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myAttentionsTableView.showsVerticalScrollIndicator = NO;
        //去掉tableview底部多余的分割线
        _myAttentionsTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_myAttentionsTableView];
    }
}

#pragma mark - UITableViewDataSource 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_myAttentionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid1 = @"cellID1";
    
    OHMyAttentionsTableViewCell *myAttentionsCell = [tableView dequeueReusableCellWithIdentifier:cellid1];
    if (myAttentionsCell == nil){
        
        myAttentionsCell = [[OHMyAttentionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
    }
    myAttentionsCell.backgroundColor = [UIColor whiteColor];
    myAttentionsCell.selectionStyle = UITableViewCellSelectionStyleNone;        //设置cell被选中时的类型
    
    //快速移除原有cell中的数据
    [myAttentionsCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    OHMyAttentionsModel *model = (OHMyAttentionsModel *)[_myAttentionsArray objectAtIndex:indexPath.row];
    [myAttentionsCell OHMyAttentionsTableViewCellConfigWithWithModel:model IndexPath:indexPath];
    
    return myAttentionsCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        OHMyAttentionsModel *model = (OHMyAttentionsModel *)[_myAttentionsArray objectAtIndex:indexPath.row];
        
        //取消关注
        [AFServer requestDataWithUrl:@"deleteFollow" andDic:@{@"sessionId": kSessionId,@"communityId":model.ID} completion:^(NSDictionary *dic) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[dic objectForKey:@"code"] integerValue]==200) {
                
                //更新数据源(数组)
                [_myAttentionsArray removeObjectAtIndex:indexPath.row];
                
                //TableView中删除对应的cell
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                
                //发布取消关注成功通知
                [[NSNotificationCenter defaultCenter] postNotificationName:CancelFollowSuccess object:nil];
                
                [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            }
            else{
                
                [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

#pragma mark - UITableViewDelegate 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中第%ld个分区的第%ld行",(long)indexPath.section, (long)indexPath.row);
    
    OHMyAttentionsModel *model = (OHMyAttentionsModel *)[_myAttentionsArray objectAtIndex:indexPath.row];
    
    OHDetailViewController *detailVC = [[OHDetailViewController alloc] init];
    detailVC.communityId = model.ID;
    detailVC.baseViewControllerCompleted = ^(NSString *state){
        
        if ([_myAttentionsArray count] != 0) {
            
            [_myAttentionsArray removeAllObjects];
        }
        //我的关注请求
        [self myAttentionsListRequestWithSessionId:kSessionId];
        
        //发布取消关注成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CancelFollowSuccess object:nil];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //行被选中后，自动变回反选状态的方法,此时deselect的代理方法不再被调用
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114*kAdaptationCoefficient;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"取消关注";
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
