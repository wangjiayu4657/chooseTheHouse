//
//  OHLiveStatusViewController.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/2.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHLiveStatusViewController.h"
#import "OHLiveCollectionCell.h"
#import "OHFrequentLocationController.h"
#import "OHFont.h"
#import "OHCommunityTagModel.h"

@interface OHLiveStatusViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellArray;  // 存放图片数组
@property (nonatomic, strong) UILabel *headLabel;         // 头部展示信息
@property (nonatomic, strong) UIButton *nextStepButton;   // 下一页按钮
@property (nonatomic, strong) NSMutableArray *selfIdArray; //用来接收上个页面传来的"社区特色"选中id的数组

@end

@implementation OHLiveStatusViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    NSString *modelId = [self.mainArray objectAtIndex:0];
    [_selfIdArray removeObject:modelId];
}
- (void)viewDidLoad {
    self.titleStr = @"生活状态";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    _selfIdArray = [NSMutableArray arrayWithCapacity:0];
    _selfIdArray = _myNewIdArray;
    [self setNextStepButton];
    [self configData];
}

- (void)configData {
    self.isCheckedArray = [[NSMutableArray alloc] init];

    NSArray *imgArray = [NSArray arrayWithObjects:@"state_zhai_icon.png",@"state_xiaozi_icon.png",@"state_work_icon.png",@"state_social_icon.png", nil];

    //collectionView数据
    _cellArray = [imgArray mutableCopy];
}

#pragma mark - 创建collectionView并设置代理
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        // 头部大小
        flowLayout.headerReferenceSize = CGSizeMake(OHScreenW*kAdaptationCoefficient, 40*kAdaptationCoefficient);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH - 50) collectionViewLayout:flowLayout];
        
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(170*kAdaptationCoefficient, 185*kAdaptationCoefficient);
        
        //定义每个UICollectionView 行间距
        flowLayout.minimumLineSpacing = 35*kAdaptationCoefficient;
        //定义每个UICollectionView item间距(最小值)
        //        flowLayout.minimumInteritemSpacing = 11*kAdaptationCoefficient;
        //定义每个UICollectionView 的边距 上左下右
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10*kAdaptationCoefficient, 0, 10*kAdaptationCoefficient);
        
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[OHLiveCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //背景颜色
        _collectionView.backgroundColor = OHColor(235, 235, 235, 1);
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}
#pragma mark - UICollectionView delegate dataSource
#pragma mark - 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_cellArray count];
}

#pragma mark 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - 每个UICollectionView展示的内容
-(OHLiveCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isCheckedArray.count == _cellArray.count) {
        
        OHLiveCollectionCell * cell = [_isCheckedArray objectAtIndex:indexPath.item];
        if (cell.isCheck) {
            cell.img2View.image = [UIImage imageNamed:@"state_checked_btn"];
            cell.stausImage.hidden = NO;
            _nextStepButton.selected = YES;
            [_nextStepButton setBackgroundColor:OHColor(251, 229, 88, 1)]; 
            [_nextStepButton setTitleColor:OHColor(105, 49, 25, 1.0) forState:UIControlStateNormal];
            
        } else {
            cell.img2View.image = [UIImage imageNamed:@"state_check_btn"];
            
        }
        return cell;
    }
    else {
        static NSString *identify = @"cell";
        OHLiveCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        cell.layer.cornerRadius = 8;
        [_isCheckedArray addObject:cell];
        //    cell.selected = NO;
        
        OHCommunityTagModel *model = [[OHCommunityTagModel alloc] init];
        model = self.dataArray[indexPath.item];
        cell.desc = model.desc;
        [cell addSubView];
        cell.isCheck = [model.isCheck boolValue];
        if (cell.isCheck) {
            cell.img2View.image = [UIImage imageNamed:@"state_checked_btn"];
            cell.stausImage.hidden = NO;
            _nextStepButton.enabled = YES;
            [_nextStepButton setBackgroundColor:OHColor(251, 229, 88, 1)];
            [_nextStepButton setTitleColor:OHColor(105, 49, 25, 1.0) forState:UIControlStateNormal];
            self.mainArray = [NSMutableArray array];
            [self.mainArray addObject:model.ID];

        } else {
            cell.img2View.image = [UIImage imageNamed:@"state_check_btn"];
        }
        
        cell.img1View.image = [UIImage imageNamed:_cellArray[indexPath.item]];
        cell.titlLabel.text = model.tagName;
        cell.txtLabel.text = model.desc;
        return cell;
    }
}

#pragma mark - UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择%ld",(long)indexPath.item);
    OHLiveCollectionCell * cell = (OHLiveCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    self.mainArray = [NSMutableArray array];
    if (cell.isCheck == YES) {
        cell.img2View.image = [UIImage imageNamed:@"state_check_btn"];
        cell.stausImage.hidden = YES;
        _nextStepButton.enabled = NO;
        [_nextStepButton setBackgroundColor:OHColor(239, 239, 239, 1)];
        [_nextStepButton setTitleColor:OHColor(160, 160, 160, 1.0) forState:UIControlStateNormal];
    } else {
        cell.img2View.image = [UIImage imageNamed:@"state_checked_btn"];
        cell.stausImage.hidden = NO;
        for (int i = 0; i < 4; i ++) {
            
            OHLiveCollectionCell * cell = [_isCheckedArray objectAtIndex:i];
            cell.isCheck = NO;
            cell.stausImage.hidden = YES;
            if (i == indexPath.item) {
                OHCommunityTagModel *model = [[OHCommunityTagModel alloc] init];
                model = self.dataArray[indexPath.item];
                [self.mainArray addObject:model.ID];
            }
        }
        _nextStepButton.enabled = YES;
        [_nextStepButton setBackgroundColor:OHColor(251, 229, 88, 1)];
        [_nextStepButton setTitleColor:OHColor(105, 49, 25, 1.0) forState:UIControlStateNormal];
    }
    
    cell.isCheck = !cell.isCheck;
    [_collectionView reloadData];
}

#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    
    [headerView addSubview:self.headLabel];
    return headerView;
}
#pragma mark - 头部描述文字label
- (UILabel *)headLabel {
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, 40*kAdaptationCoefficient)];
        _headLabel.text = @"不同的生活状态决定了不同的居住环境";
        _headLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
        _headLabel.tintColor = OHColor(102, 102, 102, 1);
        _headLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headLabel;
}
#pragma mark - 下一步按钮
- (void)setNextStepButton {
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:OHColor(160, 160, 160, 1.0) forState:UIControlStateNormal];
        _nextStepButton.frame = CGRectMake(0, OHScreenH - 50, OHScreenW, 50);
        _nextStepButton.backgroundColor = OHColor(221, 221, 221, 1);
        [_nextStepButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextStepButton.enabled = NO;
        [self.view addSubview:_nextStepButton];
    }
}

#pragma mark - 下一步按钮点击事件
- (void)nextStepAction:(UIButton *)btn {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_selfIdArray addObjectsFromArray:self.mainArray];
    self.idStrings = [_selfIdArray componentsJoinedByString:@","];
    NSLog(@"======idString+++++======%@",_idStrings);
    // 这里要调saveChooseTag，保存标签结果的idStrings
    [AFServer requestDataWithUrl:@"saveChooseTag" andDic:@{@"sessionId":kSessionId,
                                                           @"reqTagIds":self.idStrings}
     
                 completion:^(NSDictionary *dic) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     if ([[dic objectForKey:@"code"] integerValue]==200) {
                         OHFrequentLocationController *flVC = [[OHFrequentLocationController alloc] init];
                         [self.navigationController pushViewController:flVC animated:YES];
                     }
                     else{
                         [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self.view];
                     }

                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                }];

}

@end
