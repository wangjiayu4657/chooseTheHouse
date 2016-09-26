//
//  OHCommunityViewController.m
//  OptionalHome
//
//  Created by Dr_liu on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//

#define KCOLCOUNNT 3  // 列数

#import "OHCommunityViewController.h"
#import "OHLiveStatusViewController.h"
#import "OHMaskView.h"
#import "OHButton.h"
#import "OHCommunityTagModel.h"
#import "MJExtension.h"
#import "OHCommunitySubTagModel.h"

@interface OHCommunityViewController () <OHMaskViewDelegate>
{
    NSMutableArray *_myDicArr;
}
@property (nonatomic, strong) UIImageView *titleImageView; // 文字介绍图
@property (nonatomic, strong) NSMutableArray *dataArray;   // 数据
@property (nonatomic, strong) UIButton *nextStepButton;    // 下一页按钮
@property (nonatomic, strong) UIScrollView *bgScrollView;  // 滚动视图，放置九宫格
@property (nonatomic, strong) NSMutableArray* saveArray;   // *从蒙板中回调的数组*/
@property (nonatomic, strong) OHMaskView* maskView;

@end

@implementation OHCommunityViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (NSMutableArray *)saveArray {
    if (!_saveArray) {
        _saveArray = [[NSMutableArray alloc] init];
    }
    return _saveArray;
}

- (void)viewDidLoad {
    self.titleStr = @"社区特色";
    if ([kInHome integerValue]==1) {
        self.leftButtonStatus = leftButtonWithImage;
        self.leftCustomButtonImage = @"back_btn";
        self.canDragBack = YES;

    }
    else{
        self.canDragBack = NO;

    }

    [super viewDidLoad];
    self.view.backgroundColor = OHColor(230, 230, 230, 1);
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self configData:^{
      
        [self createUI];
        [self judgeData];


    }];
}

// 添加数据
- (void)configData:(void(^)(void))complete{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _myDicArr = [NSMutableArray arrayWithCapacity:0];
    [AFServer requestDataWithUrl:@"getTagList" andDic:@{@"sessionId":kSessionId} completion:^(NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
        NSMutableArray* tagModelArray = [NSMutableArray array];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSMutableArray* tagDicArray = dic[@"response"][@"tagList"];
            
            for (NSDictionary* tagDic in  tagDicArray) {
                 [tagModelArray addObject:[self intoTheModel:tagDic]];
                if ([[tagDic objectForKey:@"type"] integerValue]!=3) {
                    [_myDicArr addObject:tagDic];
                }
                
            }
            self.dataArray = tagModelArray ;
        }
        else{
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        // 下一页的数据
        NSMutableArray* nextPageArray = [NSMutableArray array];
        NSMutableArray *testArray = [NSMutableArray arrayWithCapacity:0];
        [testArray  addObjectsFromArray:_dataArray];
        for (int i = 0; i < self.dataArray.count; i++) {
            OHCommunityTagModel* model = self.dataArray[i];
            if (model.type.intValue==3) {
                [nextPageArray addObject:model];
                [testArray removeObject:model];
            }
        }
        self.dataArray = testArray;
        
        NSLog(@"self.dataArray=%@",self.dataArray);
        
        self.nextPageArray = nextPageArray ;
        if (complete) {
            complete();
        }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [OHCommon showWeakTips:@"服务器君已罢工，请稍后再试" View:self.view];

            if (complete) {
                complete();
            }
        }];
}

// 写入模型
- (OHCommunityTagModel*)intoTheModel:(NSDictionary *)dic {
    OHCommunityTagModel *model = [OHCommunityTagModel mj_objectWithKeyValues:dic context:nil];
    NSArray *dicArray = dic[@"children"] ;
    
    model.children  = [OHCommunitySubTagModel mj_objectArrayWithKeyValuesArray:dicArray];
    return model ;
}

// 创建UI
- (void)createUI {
    CGFloat marX1 = 15;
    CGFloat marX2 = 7;
    CGFloat marginY = 7;
    CGFloat KWITH = (OHScreenW - (marX1 + marX2) * 2) / 3;
    CGFloat KHEIGHT = KWITH *10/9;
    CGFloat imageH = 150;
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner-top"]];
    self.titleImageView.frame = CGRectMake(0, kNaviHeight, OHScreenW, imageH);
    [self.view addSubview:self.titleImageView];
    
    // 底部scrollview的高度
    CGFloat bgScrollViewH = OHScreenH - kNaviHeight - 150 - 50;
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNaviHeight + imageH, OHScreenW, bgScrollViewH)];
    // 设置可移动范围
    self.bgScrollView.contentSize = CGSizeMake(0, (KHEIGHT + marginY)*3 + 12);
    self.bgScrollView.showsVerticalScrollIndicator = NO;

    self.bgScrollView.bounces = NO;
    [self.view addSubview:self.bgScrollView];
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        int row = i / KCOLCOUNNT;  // 行
        int col = i % KCOLCOUNNT;  // 列
        CGFloat X = marX1 + col * (marX2 + KWITH);
        CGFloat Y = 12 + row * (marginY + KHEIGHT);
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(X, Y, KWITH, KHEIGHT);
        bgView.backgroundColor = OHColor(255, 255, 255, 1);
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4;
        bgView.tag = i + 200;
        [self.bgScrollView addSubview:bgView];
        //添加手势
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [bgView addGestureRecognizer:tap];
        
        CGFloat iconW = 65 * kAdaptationCoefficient;
        CGFloat iconH = 60 * kAdaptationCoefficient;
        CGFloat iconX = (KWITH - iconW) * 0.5;
        CGFloat iconY = 15 * kAdaptationCoefficient;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(iconX, iconY, iconW, iconH);
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iconX, iconY + iconH, KWITH, KHEIGHT-27-iconH)];
        label.font = [OHFont systemFontOfSize:16 * kAdaptationCoefficient];
        
        OHCommunityTagModel* tagModel = self.dataArray[i];
        label.text = tagModel.tagName;
        button.selected = tagModel.isCheck;
        if ([tagModel.isCheck isEqual:[NSNull null]]) {
            tagModel.isCheck =0;
        }
        if (tagModel.isCheck ==0) {
            
            if ([tagModel.tagName isEqualToString:@"四通八达"]) {
                [button setImage:[UIImage imageNamed:@"choose_traffic_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"观景居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_view_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"教育社区"]) {
                [button setImage:[UIImage imageNamed:@"choose_eduaction_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"养老居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_old_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"区域中心"]) {
                [button setImage:[UIImage imageNamed:@"choose_center_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"投资精选"]) {
                [button setImage:[UIImage imageNamed:@"choose_investment_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"经济小窝"]) {
                [button setImage:[UIImage imageNamed:@"choose_small_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"舒适住宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_comfort_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"高档大宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_grade_btn"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"choose_ask_btn"] forState:UIControlStateNormal];
            }
        }
        else{
            
            if ([tagModel.tagName isEqualToString:@"四通八达"]) {
                [button setImage:[UIImage imageNamed:@"choose_traffic_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"观景居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_view_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"教育社区"]) {
                [button setImage:[UIImage imageNamed:@"choose_eduaction_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"养老居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_old_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"区域中心"]) {
                [button setImage:[UIImage imageNamed:@"choose_center_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"投资精选"]) {
                [button setImage:[UIImage imageNamed:@"choose_investment_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"经济小窝"]) {
                [button setImage:[UIImage imageNamed:@"choose_small_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"舒适住宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_comfort_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"高档大宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_grade_highlight_btn"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"choose_ask_highlight_btn"] forState:UIControlStateNormal];
            }
        }
        
        
        label.textColor = OHColor(102, 102, 102, 1);
        [bgView addSubview:label];
    }
    
    _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepButton setTitleColor:OHColor(160, 160, 160, 1.0) forState:UIControlStateNormal];
    _nextStepButton.frame = CGRectMake(0, OHScreenH - 50, OHScreenW, 50);
    _nextStepButton.backgroundColor = OHColor(221, 221, 221, 1);
    [self.view addSubview:_nextStepButton];
    [_nextStepButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)buttonClick:(UIButton *)sender{
    NSInteger index = sender.tag;
    
    self.maskView = [[OHMaskView alloc] init];
    self.maskView.delegate = self;
    self.maskView.pageIndex = index - 100;
    self.maskView.dataArray = _myDicArr;
    self.maskView.frame = CGRectMake(0, 0, OHScreenW, OHScreenH);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskView];
}
-(void)judgeData{
    self.idArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < self.dataArray.count; i++) {
        
        OHCommunityTagModel *tagModel = self.dataArray[i];
        BOOL tagModelIsSelected = NO ;
        NSMutableArray* subTaglArray = tagModel.children;
        UIButton* button = (UIButton *)[self.view viewWithTag:i + 100];
        int number;
        number=0;
        for (int j = 0; j<subTaglArray.count; j++) {
            OHCommunitySubTagModel* subTagModel = subTaglArray[j];
            if ([subTagModel.isCheck intValue]==1) {
                [self.idArray addObject:subTagModel.ID];
                number++;
            }
        }
        BOOL isHasSubbuttonSelected = number>0?YES:NO;
        
        if (isHasSubbuttonSelected) {
            button.selected = YES;
            if ([tagModel.tagName isEqualToString:@"四通八达"]) {
                [button setImage:[UIImage imageNamed:@"choose_traffic_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"观景居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_view_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"教育社区"]) {
                [button setImage:[UIImage imageNamed:@"choose_eduaction_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"养老居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_old_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"区域中心"]) {
                [button setImage:[UIImage imageNamed:@"choose_center_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"投资精选"]) {
                [button setImage:[UIImage imageNamed:@"choose_investment_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"经济小窝"]) {
                [button setImage:[UIImage imageNamed:@"choose_small_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"舒适住宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_comfort_highlight_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"高档大宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_grade_highlight_btn"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"choose_ask_highlight_btn"] forState:UIControlStateNormal];
            }
            tagModelIsSelected = YES;
            
        } else {
            
            button.selected = NO;
            if ([tagModel.tagName isEqualToString:@"四通八达"]) {
                [button setImage:[UIImage imageNamed:@"choose_traffic_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"观景居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_view_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"教育社区"]) {
                [button setImage:[UIImage imageNamed:@"choose_eduaction_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"养老居所"]) {
                [button setImage:[UIImage imageNamed:@"choose_old_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"区域中心"]) {
                [button setImage:[UIImage imageNamed:@"choose_center_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"投资精选"]) {
                [button setImage:[UIImage imageNamed:@"choose_investment_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"经济小窝"]) {
                [button setImage:[UIImage imageNamed:@"choose_small_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"舒适住宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_comfort_btn"] forState:UIControlStateNormal];
            }
            else if ([tagModel.tagName isEqualToString:@"高档大宅"]) {
                [button setImage:[UIImage imageNamed:@"choose_grade_btn"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"choose_ask_btn"] forState:UIControlStateNormal];
            }

        }
        
        if (tagModelIsSelected) {
            // 选中的标签的id添加到字符串中
            [self.idArray addObject:tagModel.ID];
        }
        
    }

    if (self.idArray.count>0) {
        // 下一页按钮颜色
        self.nextStepButton.backgroundColor = OHColor(251, 229, 88, 1);
        [self.nextStepButton setTitleColor:OHColor(105, 49, 25, 1.0) forState:UIControlStateNormal];
        self.nextStepButton.enabled = YES;
    }
    else{
        // 下一页按钮颜色
        self.nextStepButton.backgroundColor = OHColor(221, 221, 221, 1);
        [self.nextStepButton setTitleColor:OHColor(160, 160, 160, 1.0) forState:UIControlStateNormal];
        self.nextStepButton.enabled = NO;
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    
    self.maskView = [[OHMaskView alloc] init];
    self.maskView.delegate = self;
    self.maskView.pageIndex = index - 200;
    self.maskView.dataArray = _myDicArr;
    self.maskView.frame = CGRectMake(0, 0, OHScreenW, OHScreenH);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskView];
}

- (void)nextStepAction:(UIButton *)button {
    OHLiveStatusViewController *liveStatusVC = [[OHLiveStatusViewController alloc] init];
    
    liveStatusVC.dataArray = self.nextPageArray;
    liveStatusVC.myNewIdArray = self.idArray;
    
    [self.navigationController pushViewController:liveStatusVC animated:YES];
}

#pragma mark - OHMaskViewDelegate代理方法
- (void)backData:(NSMutableArray *)saveArray{
    _myDicArr = saveArray;
    self.idArray = [NSMutableArray arrayWithCapacity:0];
    [self.dataArray removeAllObjects];
    for (NSDictionary* tagDic in  _myDicArr) {
        [_dataArray addObject:[self intoTheModel:tagDic]];
    }
    [self judgeData];
}

@end
