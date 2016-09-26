//
//  OHDetailViewController.m
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHDetailViewController.h"
#import "OHDetailTableHeaderView.h"
#import "OHSourceOfHouseCell.h"
#import "OHSurroundingInformationCell.h"
#import "OHCommunityBasicInformationCell.h"
#import "OHRightImageButton.h"
#import "OHDetailModel.h"
#import "OHDetailCellModel.h"
#import "OHSourceOfHouseCell.h"

#import "OHHouseListViewController.h"
#import "OHRightImageButton.h"
#import "OHWebViewController.h"


#pragma mark - SectionHeaderView

static CGFloat const SectionHeaderViewHeight = 50;
static CGFloat const SectionFooterViewHeight = 0.01;
static CGFloat const margin = 12;

//每组的headerView
@interface SectionHeaderView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SectionHeaderView

- (instancetype)init
{
    if (self = [super init])
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 11, 100, 40)];
        [self addSubview:self.imageView];
        
        CGFloat btnX = OHScreenW  - 185;
        CGFloat btnY = SectionHeaderViewHeight / 4 + 5;
        CGFloat btnW = 150;
        CGFloat btnH = SectionHeaderViewHeight / 2;
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(btnX,btnY,btnW,btnH);
        self.rightButton.titleLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
        [self addSubview:self.rightButton];
        self.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
        self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.rightButton.enabled = NO;
        
        CGFloat arrowX = CGRectGetMaxX(self.rightButton.frame);
        CGFloat centerY = self.rightButton.centerY;
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currency_arrow_right.png"]];
        arrowImage.x = arrowX;
        arrowImage.centerY = centerY;
        [self addSubview:arrowImage];
        
    }
    return self;
}

@end

//每组的 footerView
@interface SectionFooterView : UIView

@property (nonatomic, weak) OHRightImageButton *moreButton;

@end

@implementation SectionFooterView

- (instancetype)init
{
    if (self = [super init])
    {
        OHRightImageButton *allButton = [OHRightImageButton buttonWithType:UIButtonTypeCustom];
        allButton.frame = CGRectMake(((OHScreenW - 125) / 2) * kAdaptationCoefficient, 13 * kAdaptationCoefficient, 125 * kAdaptationCoefficient, 30 * kAdaptationCoefficient);
        [allButton setTitle:@"查看全部" forState: UIControlStateNormal];
        [allButton setBackgroundColor:[UIColor colorWithWhite:0.973 alpha:1.000]];
        allButton.layer.masksToBounds = YES;
        allButton.layer.cornerRadius = 4;
        allButton.titleLabel.font = [OHFont systemFontOfSize:14 * kAdaptationCoefficient];
        [allButton setTitleColor:[UIColor colorWithWhite:0.600 alpha:1.000] forState:UIControlStateNormal];
        [self addSubview:allButton];
        self.moreButton = allButton;
    }
    return self;
}

@end


@interface OHDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic) NSMutableArray *dataSource;
@property (strong , nonatomic) OHDetailTableHeaderView *headerView;
@property (strong , nonatomic) OHSurroundingInformationCell *surroundView;
@property (strong , nonatomic) OHCommunityBasicInformationCell *basicView;
/**模型数组*/
@property (strong , nonatomic) NSMutableArray *modelArray;

@property (weak , nonatomic) UITableView *tableView;

@property (strong , nonatomic) Singleton *singleton;

@end

@implementation OHDetailViewController

#pragma mark - 懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_w_btn";
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //加载 tabaleView 的 tableHeaderView
    [self setupTableView];
   
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OHSourceOfHouseCell class]) bundle:nil] forCellReuseIdentifier:sourceOfHouse];

    [self downloadContent];
}

- (void)baseBackButtonClick {    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , OHScreenW, OHScreenH) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [self.view insertSubview:self.naviView aboveSubview:tableView];
    self.naviView.backgroundColor = [UIColor clearColor];
    self.tableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    OHDetailTableHeaderView *headerView = [OHDetailTableHeaderView showTableHeaderView];
    headerView.communityId = self.communityId;
    headerView.completed = ^(NSString *states){
        if (weakSelf.baseViewControllerCompleted) {
            !weakSelf.baseViewControllerCompleted ? :weakSelf.baseViewControllerCompleted(states);
        }
    };
    self.headerView = headerView;
    
    OHSurroundingInformationCell *surroundView = [[OHSurroundingInformationCell alloc] init];
    surroundView.communityId = self.communityId;
    self.surroundView = surroundView;
    
    OHCommunityBasicInformationCell *basicView = [OHCommunityBasicInformationCell showBasicInformationView];
    self.basicView = basicView;
    
    self.singleton = [Singleton shareSingleton];
    
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)downloadContent {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFServer requestDataWithUrl:@"getCommunityInfo" andDic:@{@"sessionId":kSessionId,@"communityId":self.communityId} completion:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"dic = %@",dic);
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            if ([dic[@"response"][@"siteList"] isKindOfClass:[NSArray class]]) {
                self.dataSource = dic[@"response"][@"siteList"];
            }
            
            [self intoTheModel:dic[@"response"]];
           
        } else {
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [OHCommon showWeakTips:[NSString stringWithFormat:@"%@",error] View:self.view];
    }];
}

- (void)intoTheModel:(NSDictionary *) dic {
    
    OHDetailModel *model = [OHDetailModel mj_objectWithKeyValues:dic];
    
    if ([VALID_ARRAY(self.dataSource) count] != 0) {
        for (NSDictionary *dic in self.dataSource) {
            NSArray *array = [OHDetailCellModel mj_objectArrayWithKeyValuesArray:dic[@"houseList"]];
            if (array.count == 0){
                  [self.modelArray addObject:@[]];
            }else {
                  [self.modelArray addObject:array];
            }
        }
    }
  
    self.headerView.model = model;
    self.basicView.model = model;
    self.surroundView.model = model;


    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return VALID_ARRAY(self.dataSource).count + 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 3) {
        return 0;
    }else if (section == 4) {
        NSArray *array = VALID_ARRAY(self.dataSource[section - 4][@"houseList"]);
        if (array.count >= 3) {
            return 3;
        }
        return array.count;
    }else {
        NSArray *array = VALID_ARRAY(self.dataSource[section - 4][@"houseList"]);
        if (array.count >= 3) {
            return 3;
        }
        return array.count;
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    NSInteger number = 0;
    switch (section) {
        case 0:
            number = self.singleton.headerViewHeight;
            break;
        case 1:
            number = self.basicView.basicInformationViewHeight;
            break;
        case 2:
            number = self.singleton.sectionHeaderViewHeight;
            break;
        case 3:
            number = SectionHeaderViewHeight * kAdaptationCoefficient;
            break;
        case 4:
            number = (SectionHeaderViewHeight + 10) * kAdaptationCoefficient;
            break;
        case 5:
            number = (SectionHeaderViewHeight + 10) * kAdaptationCoefficient;
            break;

        default:
            break;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat number = 0;
    switch (section) {
        case 0:
            number = 20;
            break;
        case 1:
            number =  20;
            break;
        case 2:
            number =  20;
            break;
        case 3:
            number =  SectionFooterViewHeight;
            break;
        case 4:
            number =  SectionFooterViewHeight;
            break;
        case 5:
            number =  SectionFooterViewHeight;
            break;
            
        default:
            break;
    }
    return number;
   
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115 * kAdaptationCoefficient;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OHSourceOfHouseCell *sourceCell = [tableView dequeueReusableCellWithIdentifier:sourceOfHouse];
    OHDetailCellModel *model;
    if (indexPath.section > 3) {
         model = self.modelArray[indexPath.section - 4][indexPath.row];
    } 
    if (indexPath.section == 4) {
        sourceCell.siteNameLabel.text = @"房天下房源";
    }
    if (indexPath.section == 5) {
        sourceCell.siteNameLabel.text = @"链家房源";
    }
    sourceCell.model = model;
    
    return sourceCell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return self.headerView;
        }
            break;
        case 1: {
            return self.basicView;
        }
            break;
        case 2:{
            return self.surroundView;
        }
            break;
        case 3:{
            UIView *myView = [[UIView alloc] init];
            UILabel *label = [[UILabel alloc] init];
            label.text = @"货比三家才能买到好房子";
            label.font = [OHFont systemFontOfSize:17 * kAdaptationCoefficient];
            label.x = margin;
            label.width = OHScreenW - 2 * margin;
            label.height = SectionHeaderViewHeight * kAdaptationCoefficient;
            label.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
            label.textAlignment = NSTextAlignmentLeft;
            [myView addSubview:label];
            return myView;
        }
            break;
        case 4:{
             SectionHeaderView *headerView = [[SectionHeaderView alloc] init];
             headerView.imageView.image = [UIImage imageNamed:@"soufang_logo"];
             NSString *string = [NSString stringWithFormat:@"在售房源: %d套",[self.dataSource[section -4][@"houseCount"] intValue]];
             headerView.rightButton.tag = section - 4;
            [headerView.rightButton setAttributedTitle:[self changeStringWithString:string] forState:UIControlStateNormal];
            [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangtianxiaTapClick:)]];
            return headerView;
        }
            break;
        case 5:{
             SectionHeaderView *headerView = [[SectionHeaderView alloc] init];
             headerView.imageView.image = [UIImage imageNamed:@"lianjia_logo"];
             NSString *string = [NSString stringWithFormat:@"在售房源: %d套",[self.dataSource[section -4][@"houseCount"] intValue]];
             headerView.rightButton.tag = section - 4;
             [headerView.rightButton setAttributedTitle:[self changeStringWithString:string] forState:UIControlStateNormal];
             [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lianjiaTapClick:)]];
            return headerView;
        }
            break;
            
        default:
            return nil;
           break;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *myFooterView = [[UIView alloc] init];
    myFooterView.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    switch (section) {
        case 0: {
            return myFooterView;
        }
        break;
        case 1:{
            return myFooterView;
        }
          
        break;
        case 2:{
            return myFooterView;
        }
            
        break;
        case 3:{
            return nil;
        }
        break;
        case 4:{
            return nil;
        }
        break;
        case 5:{
            return nil;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void) fangtianxiaTapClick:(UITapGestureRecognizer *) tap {
    OHHouseListViewController *houseListVC = [[OHHouseListViewController alloc] init];
    houseListVC.communityId = [NSString stringWithFormat:@"%@",self.communityId];;
    houseListVC.site = @"soufun";
    [self.navigationController pushViewController:houseListVC animated:YES];

}

- (void) lianjiaTapClick:(UITapGestureRecognizer *)tap {
    OHHouseListViewController *houseListVC = [[OHHouseListViewController alloc] init];
    houseListVC.communityId = [NSString stringWithFormat:@"%@",self.communityId];
    houseListVC.site = @"lianjia";
    [self.navigationController pushViewController:houseListVC animated:YES];
}

#pragma mark - Table view Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OHDetailCellModel *model = self.modelArray[indexPath.section - 4][indexPath.row];
    OHWebViewController *webVC = [[OHWebViewController alloc] initWithURL:[NSURL URLWithString:model.infoUrl] andTitle:@"房源详情"];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (NSMutableAttributedString *) changeStringWithString:(NSString *) string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:@":"];
    
    [attrString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.600 alpha:1.000]} range:NSMakeRange(0, range.location  + range.length)];
    
    [attrString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.200 alpha:1.000],NSFontAttributeName:[OHFont systemFontOfSize:17 * kAdaptationCoefficient]} range:NSMakeRange(range.location + range.length, string.length - range.location - range.length)];
    
    [attrString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.600 alpha:1.000]} range:NSMakeRange(string.length - 1, 1)];
    
    return attrString;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
