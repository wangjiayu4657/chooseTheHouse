//
//  OHHouseListViewController.m
//  OptionalHome
//
//  Created by lujun on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHHouseListViewController.h"
#import "OHHouseListTableViewCell.h"
#import "OHWebViewController.h"

#import "OHHouseListModel.h"

#import "MJRefresh.h"

@interface OHHouseListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_houseListTableView;       //房源列表页tableview
    
    NSMutableArray *_houseListArray;        //房源列表数据源
    
    __block NSInteger _listCount;           //当前是第几页
    __block NSInteger _totalCount;
}
@end

@implementation OHHouseListViewController

- (void)viewDidLoad {
    
    if ([self.site isEqualToString:@"soufun"]) {
        self.titleStr = @"房天下在售房源";
    }
    else if ([self.site isEqualToString:@"lianjia"]) {
        self.titleStr = @"链家在售房源";
    }
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _houseListArray = [[NSMutableArray alloc] init];
    _listCount = 0;
    _totalCount = 0;
    
    //房源列表请求
    [self houseListRequestWithSessionId:kSessionId CommunityId:self.communityId Site:self.site];
    
    //创建房源列表页TableView
    [self initHouseListTableView];
}

//房源列表请求
- (void)houseListRequestWithSessionId:(NSString *)sessionId CommunityId:(NSString *)communityId Site:(NSString *)site {

    NSString *listCount = [NSString stringWithFormat:@"%ld",(long)_listCount];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"getHouseList" andDic:@{@"sessionId":sessionId, @"communityId":communityId, @"site":site, @"startIndex":listCount, @"pageCount":@"10"} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            _totalCount = [[[dic objectForKey:@"response"] objectForKey:@"count"] integerValue];
            
            if ([[dic objectForKey:@"response"] objectForKey:@"houseList"] != [NSNull null]) {
                for (NSDictionary *listDic in [[dic objectForKey:@"response"] objectForKey:@"houseList"]) {
                    
                    OHHouseListModel *houseListModel = [OHHouseListModel mj_objectWithKeyValues:listDic];
                    [_houseListArray addObject:houseListModel];
                }
            }
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
        //上拉加载更多 隐藏
        if ([_houseListArray count] == 0 || [_houseListArray count] == _totalCount) {
            _houseListTableView.mj_footer.hidden = YES;
        }
        else {
            _houseListTableView.mj_footer.hidden = NO;
        }
        
        [_houseListTableView reloadData];
        [_houseListTableView.mj_header endRefreshing];
        [_houseListTableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_houseListTableView.mj_header endRefreshing];
        [_houseListTableView.mj_footer endRefreshing];
    }];
}

//创建房源列表页TableView
- (void)initHouseListTableView {
    
    _houseListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH-kNaviHeight) style:UITableViewStylePlain];
    _houseListTableView.backgroundColor = [UIColor clearColor];
    _houseListTableView.delegate = self;
    _houseListTableView.dataSource = self;
    _houseListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _houseListTableView.showsVerticalScrollIndicator = NO;
    //去掉tableview底部多余的分割线
    _houseListTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_houseListTableView];
    
    //下拉刷新
    _houseListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _listCount = 0;
        if ([_houseListArray count] != 0) {
            [_houseListArray removeAllObjects];
        }
        //房源列表请求
        [self houseListRequestWithSessionId:kSessionId CommunityId:self.communityId Site:self.site];
    }];
    
    //上拉加载更多
    _houseListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _listCount += 10;
        
        //房源列表请求
        [self houseListRequestWithSessionId:kSessionId CommunityId:self.communityId Site:self.site];
    }];
}

#pragma mark - UITableViewDataSource 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_houseListArray count] != 0) {
        return [_houseListArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid1 = @"cellID1";
    
    OHHouseListTableViewCell *houseListCell = [tableView dequeueReusableCellWithIdentifier:cellid1];
    if (houseListCell == nil){
        
        houseListCell = [[OHHouseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid1];
    }
    houseListCell.backgroundColor = [UIColor whiteColor];
    houseListCell.selectionStyle = UITableViewCellSelectionStyleNone;        //设置cell被选中时的类型
    
    //快速移除原有cell中的数据
    [houseListCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    OHHouseListModel *model = (OHHouseListModel *)[_houseListArray objectAtIndex:indexPath.row];
    [houseListCell OHHouseListTableViewCellConfigWithWithModel:model Site:self.site IndexPath:indexPath];
    
    return houseListCell;
}

#pragma mark - UITableViewDelegate 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中第%ld个分区的第%ld行",(long)indexPath.section, (long)indexPath.row);
    
    OHHouseListModel *model = (OHHouseListModel *)[_houseListArray objectAtIndex:indexPath.row];
    
    OHWebViewController *webVC = [[OHWebViewController alloc] initWithURL:[NSURL URLWithString:model.infoUrl] andTitle:@"房源详情"];
    [self.navigationController pushViewController:webVC animated:YES];
    
    //行被选中后，自动变回反选状态的方法,此时deselect的代理方法不再被调用
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115*kAdaptationCoefficient;
}

#pragma mark - UIScrollViewDelegate 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    NSLog(@"height:%f scrollView.contentSize.height:%f contentYoffset:%f frame.y:%f",height,scrollView.contentSize.height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom <= height && [_houseListArray count] == _totalCount) {
        
        [OHCommon showWeakTips:@"没有更多数据了哦" View:self.view];
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
