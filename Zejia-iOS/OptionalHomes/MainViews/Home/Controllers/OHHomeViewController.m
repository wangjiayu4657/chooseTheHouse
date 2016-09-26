//
//  OHHomeViewController.m
//  OptionalHome
//
//  Created by haili on 16/7/25.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHHomeViewController.h"
#import "OHHomeListModel.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WeiboSDK.h"

#import "OHLoginViewController.h"
#import "OHChooseLoginWayView.h"
#import "OHHomeTopScreenView.h"
#import "OHTextAndImageButton.h"
#import "OHScreenPullView.h"
#import "OHSideScreenView.h"
#import "OHHomeListTableViewCell.h"
#import "OHDetailViewController.h"
#import "MJRefresh.h"
#import "OHCommunityViewController.h"
#import "OHWebViewController.h"

#import "OHLoginModel.h"
#import "OHScreenModel.h"

@interface OHHomeViewController ()<OHChooseLoginWayViewDelegate,OHHomeTopScreenViewDelegate, TencentSessionDelegate, WBHttpRequestDelegate, TencentApiInterfaceDelegate,OHScreenPullViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    TencentOAuth *tencentOAuth;
    NSString *openID;
    OHHomeTopScreenView *_screenView;
    NSString *_topAreaSelectedStr;          //区域已选的字段
    NSString *_topPriceSelectedStr;         //价格已选的字段
    NSString *_topIntelligentSelectedStr;   //智能排序已选的字段

    NSString *_topAreaSelectedId;          //区域已选的字段code
    NSString *_topPriceSelectedId;         //价格已选的字段code
    NSString *_topIntelligentSelectedId;   //智能排序已选的字段code
    
    UITableView *_mainTableView;           //表
    OHChooseLoginWayView *_chooseLoginWayView;  //选择登录方式的view
    NSMutableArray *_HomeListArr;               //列表数据的数组
    __block NSInteger _pageNum;             //页码
    __block NSInteger _limitEnd;            //索引
    NSInteger _allCount;                    //所有数据条数
    
    NSMutableArray *_areaArr;                //区域的数组
    NSMutableArray *_priceArr;               //价格的数组
    NSMutableArray *_intelligentArr;         //智能的数组
}

@end

@implementation OHHomeViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self judgeHomePageShowWay];
}

- (void)viewDidLoad {
    
    //注册通知（监听新浪微博登录成功）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sinaLoginSuccess:) name:SinaLoginSuccess object:nil];
    
    //注册通知（监听微信登录成功）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginSuccess:) name:WechatLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFollowSuccess) name:CancelFollowSuccess object:nil];
    
    self.titleStr = @"择家";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"home_tab_icon";
    self.rightButtonStatus = rightButtonWithImage;
    self.rightCustomButtonImage = @"home_screen_icon";
    self.canDragBack = NO;
    [super viewDidLoad];
    self.view.backgroundColor = OHColor(243, 243, 255, 1.0);
    _HomeListArr = [[NSMutableArray alloc] initWithCapacity:0];
    _topAreaSelectedId = @"";
    _topPriceSelectedId = @"";
    _topIntelligentSelectedId = @"";

    [self setLocalData];
}

//取消关注成功刷表
-(void)cancelFollowSuccess{
    [self screenResetAndRefreshHomePage];

}
//设置本地的json的数据
-(void)setLocalData{
    _areaArr = [NSMutableArray arrayWithCapacity:0];
    _priceArr = [NSMutableArray arrayWithCapacity:0];
    _intelligentArr = [NSMutableArray arrayWithCapacity:0];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HomeScreenData" ofType:@"json"];
    NSData *returnData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    if (returnData) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:&err];
        for (NSDictionary *areaDic in [dic  objectForKey:@"Area"]) {
            
            OHScreenModel *model = [OHScreenModel mj_objectWithKeyValues:areaDic];
            [_areaArr addObject:model];
        }
        for (NSDictionary *areaDic in [dic  objectForKey:@"Price"]) {
            
            OHScreenModel *model = [OHScreenModel mj_objectWithKeyValues:areaDic];
            [_priceArr addObject:model];
        }
        for (NSDictionary *areaDic in [dic  objectForKey:@"Intelligent"]) {
            
            OHScreenModel *model = [OHScreenModel mj_objectWithKeyValues:areaDic];
            [_intelligentArr addObject:model];
        }
    }
    
}
//pop回来刷新界面
- (void)resetSomeThing{
    [_mainTableView removeFromSuperview];
    _mainTableView = nil;
    [_screenView removeFromSuperview];
    _screenView = nil;
    OHScreenPullView *pullView = (OHScreenPullView *)[self.view viewWithTag:100];
    [pullView removeFromSuperview];
    OHScreenPullView *pullView1 = (OHScreenPullView *)[self.view viewWithTag:200];
    [pullView1 removeFromSuperview];
    OHScreenPullView *pullView2 = (OHScreenPullView *)[self.view viewWithTag:300];
    [pullView2 removeFromSuperview];
    _topAreaSelectedId = @"";
    _topPriceSelectedId = @"";
    _topIntelligentSelectedId = @"";
    _topAreaSelectedStr = @"";
    _topPriceSelectedStr = @"";
    _topIntelligentSelectedStr = @"";
    _HomeListArr = [[NSMutableArray alloc] initWithCapacity:0];
}
//数据请求
-(void)requestData:(void(^)(void))complete{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"getMatchCommunity" andDic:@{@"sessionId":kSessionId,@"startIndex":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageCount":[NSString stringWithFormat:@"%ld",(long)_limitEnd],@"regionCompose":_topAreaSelectedId,@"priceCompose":_topPriceSelectedId,@"orderCompose":_topIntelligentSelectedId} completion:^(NSDictionary *dic) {
        NSLog(@"===========%@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            _allCount = [[[dic objectForKey:@"response"] objectForKey:@"count"] integerValue];
            if ([[[dic objectForKey:@"response"] objectForKey:@"communityList"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *listDic in [[dic objectForKey:@"response"] objectForKey:@"communityList"]) {
                    OHHomeListModel *listModel = [OHHomeListModel mj_objectWithKeyValues:listDic];
                    [_HomeListArr addObject:listModel];
                }
            }
            [_mainTableView reloadData];
        }
        else{
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        //上拉加载隐藏
        if (_HomeListArr.count == _allCount||_HomeListArr.count==0) {
            _mainTableView.mj_footer.hidden = YES;
        }
        else{
            _mainTableView.mj_footer.hidden = NO;

        }
        [_mainTableView.mj_footer endRefreshing];
        [_mainTableView.mj_header endRefreshing];
        if (complete) {
            complete();
        }

    } failure:^(NSError *error) {
        NSLog(@"===========error,%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [OHCommon showWeakTips:@"服务器君已罢工，请稍后再试" View:self.view];
        [_mainTableView.mj_footer endRefreshing];
        [_mainTableView.mj_header endRefreshing];
    }];
}
#pragma mark - UIScrollViewDelegate 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    NSLog(@"height:%f scrollView.contentSize.height:%f contentYoffset:%f frame.y:%f",height,scrollView.contentSize.height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom <= height && [_HomeListArr count] == _allCount) {
        
        [OHCommon showWeakTips:@"没有更多数据了哦" View:self.view];
    }
}
//判断首页的页面显示
-(void)judgeHomePageShowWay{
    //如果登录成功 直接进首页 如果未登录，则进登录方式选择页
    //没有登录
    if (!kSessionId) {
        if (!_chooseLoginWayView) {
            _chooseLoginWayView = [[OHChooseLoginWayView alloc] initWithFrame:CGRectMake(0,0, OHScreenW, OHScreenH)];
            _chooseLoginWayView.delegate  = self;
            _chooseLoginWayView.backgroundColor = [UIColor brownColor];
            [self.view addSubview:_chooseLoginWayView];
        }

    }
    else{
        
        [_chooseLoginWayView removeFromSuperview];
        _chooseLoginWayView =nil;
        if (_screenView==nil) {
            _screenView = [[OHHomeTopScreenView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, 48*kAdaptationCoefficient)];
            _screenView.delegate = self;
            _screenView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_screenView];
        }
        if (_mainTableView) {
            [_mainTableView reloadData];
        }
        else
        {
            //列表
            _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_screenView.frame), OHScreenW, OHScreenH-CGRectGetMaxY(_screenView.frame))];
            _mainTableView.dataSource = self;
            _mainTableView.delegate = self;
            _mainTableView.backgroundColor = [UIColor clearColor];
            _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
            [self.view addSubview:_mainTableView];
            //上拉加载刷新
            _mainTableView.mj_header.automaticallyChangeAlpha = YES;
            _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _pageNum +=10;
                _limitEnd = 10;
                [self requestData:nil];
                
            }];
            //下拉刷新
            _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _mainTableView.mj_footer.hidden = NO;
                _pageNum = 0;
                _limitEnd = 10;
                [_HomeListArr removeAllObjects];
                
                //请求数据
                [self requestData:nil];
            }];
            _pageNum = 0;
            _limitEnd = 10;
            [self requestData:nil];
            
        }
        
    }
}
//筛选重置后刷新首页的UI及数据
-(void)screenResetAndRefreshHomePage{
    _topAreaSelectedId = @"";
    _topPriceSelectedId = @"";
    _topIntelligentSelectedId = @"";
    _topAreaSelectedStr = @"";
    _topPriceSelectedStr = @"";
    _topIntelligentSelectedStr = @"";
    OHScreenPullView *pullView = (OHScreenPullView *)[self.view viewWithTag:100];
    [pullView removeFromSuperview];
    OHScreenPullView *pullView1 = (OHScreenPullView *)[self.view viewWithTag:200];
    [pullView1 removeFromSuperview];
    OHScreenPullView *pullView2 = (OHScreenPullView *)[self.view viewWithTag:300];
    [pullView2 removeFromSuperview];
    [_screenView removeFromSuperview];
    _screenView = nil;
    _screenView = [[OHHomeTopScreenView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, 48*kAdaptationCoefficient)];
    _screenView.delegate = self;
    _screenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_screenView];
    [self requestDataAgain];
}
//重新请求数据
-(void)requestDataAgain{
    [_HomeListArr removeAllObjects];
    _pageNum = 0;
    _limitEnd = 10;
    [self requestData:^{
    [_mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    }];
    

}
#pragma mark-UITableViewDataSource,UITableViewDelegate 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HomeListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OHHomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
         cell = [[OHHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    OHHomeListModel *model = [_HomeListArr objectAtIndex:indexPath.row];
    [cell setCellWith:model];
    cell.attentionBlock = ^(UIButton *btn){
        btn.tag = indexPath.row;
        NSLog(@"关注");
        [self addOrCancelFollow:btn];
    };
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 272*kAdaptationCoefficient;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"详情");
    OHHomeListModel *model = [_HomeListArr objectAtIndex:indexPath.row];
    OHDetailViewController *detailVC = [[OHDetailViewController alloc] init];
    __block NSIndexPath *index = indexPath;
    detailVC.baseViewControllerCompleted = ^(NSString *state){
        if ([state isEqualToString:@"add"]) {
            model.isFollow = [NSNumber numberWithInt:1];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index.row inSection:0];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            model.isFollow = [NSNumber numberWithInt:0];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index.row inSection:0];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    detailVC.communityId = model.communityId;
    [self.navigationController pushViewController:detailVC animated:YES];
   
}
//新增或取消关注
-(void)addOrCancelFollow:(UIButton *)sender{
    OHHomeListModel *model = [_HomeListArr objectAtIndex:sender.tag];
    if ([model.isFollow integerValue]==0) {
        //新增关注
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [AFServer requestDataWithUrl:@"addFollow" andDic:@{@"sessionId": kSessionId,@"communityId":model.communityId} completion:^(NSDictionary *dic) {
            NSLog(@"=== //新增关注==%@",[dic objectForKey:@"msg"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if ([[dic objectForKey:@"code"] integerValue]==200) {
                model.isFollow = [NSNumber numberWithInt:1];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];

            }else{
                [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            }
        } failure:^(NSError *error) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];

             [OHCommon showWeakTips:@"请求失败，请稍后再试" View:self.view];
        }];
        
    }
    else if ([model.isFollow integerValue]==1) {
        //删除关注
        [AFServer requestDataWithUrl:@"deleteFollow" andDic:@{@"sessionId": kSessionId,@"communityId":model.communityId} completion:^(NSDictionary *dic) {
            NSLog(@"=== //删除关注==%@",dic);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[dic objectForKey:@"code"] integerValue]==200) {
                model.isFollow = [NSNumber numberWithInt:0];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];

            }else{
                [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
            }
            
        } failure:^(NSError *error) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [OHCommon showWeakTips:@"请求失败，请稍后再试" View:self.view];

        }];
        
    }

}

#pragma mark-OHChooseLoginWayViewDelegate 代理方法
-(void)everyBtnClick:(NSInteger)btnIndex{
    switch (btnIndex) {
        case 10:
        {
            NSLog(@"微信登录按钮");
            [Singleton shareSingleton].wechatType = @"gotoLogin"; //单例
            //授权登录接入
            //构造SendAuthReq结构体
            SendAuthReq* req =[[SendAuthReq alloc ] init ];
            req.scope = @"snsapi_userinfo" ;
            req.state = @"shizhongjiaoshi_987654321" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
        }
            break;
        case 20:
        {
            NSLog(@"qq登录按钮");
            tencentOAuth = [[TencentOAuth alloc] initWithAppId:Tencent_AppID andDelegate:self];
            NSArray* permissions = [NSArray arrayWithObjects:
                                    kOPEN_PERMISSION_GET_USER_INFO,
                                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                    nil];
            [tencentOAuth authorize:permissions inSafari:YES];
        }
            break;
        case 30:
        {
            NSLog(@"微博登录按钮");
            [Singleton shareSingleton].sinaType = @"gotoUnionLogin"; //单例
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = @"http://sns.whalecloud.com/sina2/callback";
            request.userInfo = @{
                                 @"SSO_From" : @"SendMessageToWeiboViewController",
                                 @"Other_Info_1" : [NSNumber numberWithInt:123],
                                 @"Other_Info_2" : @[ @"obj1", @"obj2" ],
                                 @"Other_Info_3" : @{@"key1" : @"obj1", @"key2" : @"obj2"}
                                 };
            [WeiboSDK sendRequest:request];
        }
            break;
        case 40:
        {
            NSLog(@"手机登录按钮");
            OHLoginViewController *loginVC = [[OHLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
            break;
        case 50:
        {
            NSLog(@"解释说明按钮");
            OHWebViewController *explainVC = [[OHWebViewController alloc] initWithURL:[NSURL URLWithString:AGREEMENTURL] andTitle:@"用户协议"];
            [self.navigationController pushViewController:explainVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark-OHHomeTopScreenViewDelegate 代理方法
-(void)everyScreenBtnClick:(NSInteger)btnIndex btn:(OHTextAndImageButton *)btn
{

    switch (btnIndex) {
        case 10:
        {
            if (!btn.isSelected) {
                OHScreenPullView *pullView = (OHScreenPullView *)[self.view viewWithTag:100];
                pullView.selectBtn = btn;
                [pullView endView];
            }
            else{
                
                OHScreenPullView *pullView1 = (OHScreenPullView *)[self.view viewWithTag:200];
                [pullView1 endView];
                OHScreenPullView *pullView2 = (OHScreenPullView *)[self.view viewWithTag:300];
                [pullView2 endView];
                
                OHScreenPullView *pullView = [[OHScreenPullView alloc] initWithFrame:CGRectMake(0, kNaviHeight+CGRectGetHeight(_screenView.frame), OHScreenW, OHScreenH-kNaviHeight-CGRectGetHeight(_screenView.frame))];
                [self.view addSubview:pullView];
                pullView.backgroundColor = [OHColor(0, 0, 0, 1) colorWithAlphaComponent:0.2];
                pullView.delegate = self;
                pullView.selectBtn = btn;
                pullView.selectName = _topAreaSelectedStr;
                pullView.tag = 100;
                pullView.selectArr = _areaArr;
                [pullView initWithselecttArr];
                [pullView setView];
                
            }
            
        }
            break;
        case 20:
        {
            if (!btn.isSelected) {
                OHScreenPullView *pullView = (OHScreenPullView *)[self.view viewWithTag:200];
                pullView.selectBtn = btn;
                [pullView endView];
            }
            else{
                OHScreenPullView *pullView1 = (OHScreenPullView *)[self.view viewWithTag:100];
                [pullView1 endView];
                OHScreenPullView *pullView2 = (OHScreenPullView *)[self.view viewWithTag:300];
                [pullView2 endView];
                
                OHScreenPullView *pullView = [[OHScreenPullView alloc] initWithFrame:CGRectMake(0, kNaviHeight+CGRectGetHeight(_screenView.frame), OHScreenW, OHScreenH-kNaviHeight-CGRectGetHeight(_screenView.frame))];
                [self.view addSubview:pullView];
                pullView.backgroundColor = [OHColor(0, 0, 0, 1) colorWithAlphaComponent:0.2];
                pullView.delegate = self;
                pullView.selectBtn = btn;
                pullView.selectName = _topPriceSelectedStr;
                pullView.tag = 200;
                pullView.backgroundColor = [OHColor(0, 0, 0, 1) colorWithAlphaComponent:0.2];
                 pullView.selectArr = _priceArr;
                [pullView setView];
                [pullView initWithselecttArr];
            }
            
        }
            break;
        case 30:
        {
            if (!btn.isSelected) {
                OHScreenPullView *pullView = (OHScreenPullView *)[self.view viewWithTag:300];
                pullView.selectBtn = btn;
                [pullView endView];
            }
            else{
                OHScreenPullView *pullView1 = (OHScreenPullView *)[self.view viewWithTag:100];
                [pullView1 endView];
                OHScreenPullView *pullView2 = (OHScreenPullView *)[self.view viewWithTag:200];
                [pullView2 endView];
                
                OHScreenPullView *pullView = [[OHScreenPullView alloc] initWithFrame:CGRectMake(0, kNaviHeight+CGRectGetHeight(_screenView.frame), OHScreenW, OHScreenH-kNaviHeight-CGRectGetHeight(_screenView.frame))];
                [self.view addSubview:pullView];
                pullView.backgroundColor = [OHColor(0, 0, 0, 1) colorWithAlphaComponent:0.2];
                pullView.delegate = self;
                pullView.selectBtn = btn;
                pullView.selectName = _topIntelligentSelectedStr;
                pullView.tag = 300;
                pullView.backgroundColor = [OHColor(0, 0, 0, 1) colorWithAlphaComponent:0.2];
               pullView.selectArr =_intelligentArr;
                [pullView setView];
                [pullView initWithselecttArr];
            }
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark-OHScreenPullViewDelegate 代理方法
- (void)selectTableRow:(OHScreenPullView *)selectView btnTag:(NSInteger)btnTag selectStr:(NSString *)selectStr selectIndex:(NSString*)index{
    OHTextAndImageButton *selectBtn = (OHTextAndImageButton *)[self.view viewWithTag:btnTag];
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat angle;
        angle = -M_PI*2;
        selectBtn.buttomImage.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
        
    }];
    
    [selectBtn setButtomImage:@"home_arrow_down" title:selectStr];
    selectBtn.buttomLable.textColor = OHColor(255, 120, 0, 1.0);
    switch (selectBtn.tag) {
        case 10:
        {
            _topAreaSelectedStr = selectStr;
            _topAreaSelectedId = index;
            [self requestDataAgain];
        }
            break;
        case 20:
        {
            _topPriceSelectedStr = selectStr;
            _topPriceSelectedId = index;
             [self requestDataAgain];
            
        }
            break;
        case 30:
        {
            _topIntelligentSelectedStr = selectStr;
            _topIntelligentSelectedId = index;
             [self requestDataAgain];
            
        }
            break;
            
        default:
            break;
    }

}
- (void) rightCustomButtonClick:(UIButton *)button{
    OHSideScreenView *sideView = [[OHSideScreenView alloc] initWithFrame:CGRectMake(0, 0, OHScreenW , OHScreenH)];
    sideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

    sideView.completed = ^{
        //刷新首页
        [self screenResetAndRefreshHomePage];
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:sideView];
}

-(void)baseBackButtonClick {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC openLeftView];//打开左侧抽屉
}

#pragma mark - QQ联合登录 代理方法
- (void)tencentDidNotLogin:(BOOL)cancelled{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (cancelled) {
        
        NSLog(@"用户取消登录");
    }
    else {
        
        NSLog(@"登录失败");
    }
}

- (void)tencentDidLogin{
    
    if (tencentOAuth.accessToken && [tencentOAuth.accessToken length] != 0) {
        
        openID = tencentOAuth.openId;
        
        if (![tencentOAuth getUserInfo]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，获取token失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - QQ登录获取用户信息 委托方法
- (void)getUserInfoResponse:(APIResponse*) response {
    
    if (response.retCode == URLREQUEST_SUCCEED) {  //获取用户信息成功
        
        NSString * nickName = [response.jsonResponse objectForKey:@"nickname"];
        NSString * headImage = [response.jsonResponse objectForKey:@"figureurl_qq_2"];
        
        //QQ登录成功之后，请求服务器登录数据
        [self UnionLogin:openID NickName:nickName Avatar:headImage Type:@"qq"];
    }
    else { //获取用户信息失败
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)tencentDidNotNetWork{
    
    NSLog(@"无网络连接");
}

//新浪微博登录成功，回掉通知
- (void)sinaLoginSuccess:(NSNotification*)notification {
    
    NSDictionary *dic = notification.object;
    openID = [dic objectForKey:@"accessToken"];
    NSString * uid = [dic objectForKey:@"userID"];
    
    NSDictionary *dicParam =[NSDictionary dictionaryWithObjects:@[uid,openID,Sina_AppKey] forKeys:@[@"uid",@"access_token",@"source"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dicParam delegate:self withTag:nil];
}

#pragma mark - 新浪微博登录 代理方法
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取微博用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)respons {
    
}

#pragma mark - 新浪微博联合登录 代理方法
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSDictionary *dic = [OHCommon dictionaryWithJsonString:result];
    
    if (dic == nil || ![dic isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSString *nickName = [dic objectForKey:@"name"];
    NSString *uid = [dic objectForKey:@"id"];
    NSString *headImage = [dic objectForKey:@"avatar_large"];
    
    //新浪微博登录成功之后，请求服务器登录数据
    [self UnionLogin:uid NickName:nickName Avatar:headImage Type:@"weibo"];
}

//微信登录成功通知
- (void)wechatLoginSuccess:(NSNotification *)notification {
    
    NSDictionary *dic = notification.object;
    openID = [dic objectForKey:@"openid"];
    NSString *nickName = [dic objectForKey:@"nickname"];
    NSString *headImage = [dic objectForKey:@"headimgurl"];
    
    //微信登录成功之后，请求服务器登录数据
    [self UnionLogin:openID NickName:nickName Avatar:headImage Type:@"weixin"];
}

//第三方联合登录成功后，调用服务器的登录请求
- (void)UnionLogin:(NSString *)openId NickName:(NSString *)nickname Avatar:(NSString *)avatar Type:(NSString *)type {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"userLoginByOther" andDic:@{@"openId":openId,@"nickname":nickname,@"avatarUrl":avatar,@"type":type} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            OHLoginModel *loginModel = [OHLoginModel mj_objectWithKeyValues:[dic objectForKey:@"response"]];
            
            //保存sessionId、nickName、avaterUrl、inHome到本地
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.sessionId forKey:@"SessionId"];
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.nickname forKey:@"NickName"];
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.photoUrl forKey:@"AvaterUrl"];
            [[NSUserDefaults standardUserDefaults] setObject:loginModel.inHome forKey:@"InHome"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"kSessionIdkSessionId_UnionLogin=%@",kSessionId);
            
            //登录成功后，数据统计
            [XXReporter setUserID:kSessionId];
            
            if ([kInHome isEqualToString:@"1"]) {       //去首页
            
                //登录成功，跳转到首页
                [self viewWillAppear:YES];
            }
            else {      //去标签页
                
                //登录成功，跳转到社区特色页
                OHCommunityViewController *communityVC = [[OHCommunityViewController alloc] init];
                [self.navigationController pushViewController:communityVC animated:YES];
            }
        }
        else {
            
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
