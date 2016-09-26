//
//  OHSideScreenView.m
//  OptionalHome
//
//  Created by fangjs on 16/7/30.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHSideScreenView.h"
#import "OHCollectionViewLeftAlignedLayout.h"
#import "OHSideCollectionViewCell.h"
#import "OHSideHeaderView.h"
#import "OHSideFooterView.h"
#import "OHDataTool.h"
#import "OHCommunityViewController.h"

//动画时间
#define duration 0.25
//左侧边距
#define sideDistance 35
//每行的列数
#define columnsOfEachrow 3

static float const itemHeight                                 = 28;
static float const HeaderViewHeight                           = 35;
static float const FooterViewHeight                           = 37;
static float const kCollectionViewToLeftMargin                = 12;
static float const kCollectionViewToRightMargin               = 12;
static float const kCollectionViewToTopMargin                 = 12;
static float const kCollectionViewToBottomtMargin             = 10;
static float const kCollectionViewCellsHorizonMargin          = 15;
static float const kCollectionViewCellsVerticalMargin         = 15;
static float const kCellBtnCenterToBorderMargin               = 20;

typedef void(^ISLimitWidth)(BOOL yesORNo, id data);

@interface OHSideScreenView ()<UICollectionViewDataSource,UICollectionViewDelegate,OHSideHeaderViewDelegate>
//侧边筛选界面
@property (weak , nonatomic)  UIView *sideView;

@property (strong , nonatomic) UICollectionView *collectionView;

//@property (nonatomic, strong) NSArray          *dataSource;
@property (nonatomic, strong) NSMutableArray   *firstRowCellCountArray;
@property (nonatomic, strong) NSMutableArray   *expandSectionArray;
@property (nonatomic, strong) NSArray          *rowsCountPerSection;
@property (nonatomic, strong) NSArray          *cellsCountArrayPerRowInSections;

/**存储选中 cell 的 内容*/
@property (strong , nonatomic) NSMutableArray *contentsArray;

//每组组头的标题
@property (nonatomic, strong) NSArray          *sectionTitleArray;

@property (strong , nonatomic) NSMutableArray *tagContentArray;



//存储每组的内容
@property (strong , nonatomic) NSMutableArray *sectionContentArray0;
@property (strong , nonatomic) NSMutableArray *sectionContentArray1;
@property (strong , nonatomic) NSMutableArray *sectionContentArray2;
@property (strong , nonatomic) NSMutableArray *sectionContentArray3;
@property (strong , nonatomic) NSMutableArray *sectionContentArray4;
@property (strong , nonatomic) NSMutableArray *sectionContentArray5;
@property (strong , nonatomic) NSMutableArray *sectionContentArray6;
@property (strong , nonatomic) NSMutableArray *sectionContentArray7;
@property (strong , nonatomic) NSMutableArray *sectionContentArray8;
@property (strong , nonatomic) NSMutableArray *sectionContentArray9;

//需要上传的数据
/**家庭成员*/
@property (strong , nonatomic) NSString *familyCompose;
/**家庭生活*/
@property (strong , nonatomic) NSString *lifeCompose;
/**社区属性*/
@property (strong , nonatomic) NSString *communityCompose;
/**基础设施*/
@property (strong , nonatomic) NSString *infrastructureCompose;
/**社区配套*/
@property (strong , nonatomic) NSString *supportCompose;
/**房型*/
@property (strong , nonatomic) NSString *layoutCompose;
/**房屋类型*/
@property (strong , nonatomic) NSString *houseTypeCompose;
/**建筑年代*/
@property (strong , nonatomic) NSString *buildAgeCompose;
/**面积*/
@property (strong , nonatomic) NSString *areaCompose;
/**房屋年限*/
@property (strong , nonatomic) NSString *houseLifeCompose;


///**filterCheck:已选择的筛选条件*/
@property (strong , nonatomic) NSMutableArray *filterCheckArray;

/**将存储的标签*/
@property (strong , nonatomic) NSMutableDictionary *tagsDictionary;

///**清空标志*/
//@property (assign , nonatomic)  BOOL clearFlag;



@end

@implementation OHSideScreenView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSideView];
        [self initData];
        
        [self setupCollectionView];
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
        [self createBottomButton];
        [self downLoadTags];
        [self judgeMoreButtonShowWhenDefaultRowsCount:3];
    }
    return self;
    
}


#pragma mark - 懒加载

- (NSMutableArray *)firstRowCellCountArray {
    if (_firstRowCellCountArray == nil) {
        _firstRowCellCountArray = [NSMutableArray arrayWithCapacity:self.tagContentArray.count];
        [self.tagContentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:obj];
//            NSUInteger secondRowCellCount = [self firstRowCellCountWithArray:items];
//            NSLog(@"secondRowCellCount == %zd",secondRowCellCount);
            //每一行都显示3个
            [self.firstRowCellCountArray addObject:@(3)];
        }];
    }
    return _firstRowCellCountArray;
}

- (NSMutableArray *)expandSectionArray {
    if (_expandSectionArray == nil) {
        _expandSectionArray = [[NSMutableArray alloc] init];
    }
    return _expandSectionArray;
}
//每组的列数
- (NSArray *)rowsCountPerSection {
    if (_rowsCountPerSection == nil) {
        _rowsCountPerSection = [[NSArray alloc] init];
        NSMutableArray *rowsCountPerSection = [NSMutableArray array];
        [self.tagContentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:obj];
            NSUInteger secondRowCellCount = [[self cellsInPerRowWhenLayoutWithArray:items] count];
            [rowsCountPerSection addObject:@(secondRowCellCount)];
        }];
        _rowsCountPerSection = (NSArray *)rowsCountPerSection;
    }
    return _rowsCountPerSection;
}

- (NSArray *)cellsCountArrayPerRowInSections {
    if (_cellsCountArrayPerRowInSections == nil) {
        _cellsCountArrayPerRowInSections = [[NSArray alloc] init];
        NSMutableArray *cellsCountArrayPerRowInSections = [NSMutableArray array];
        [self.tagContentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:obj];
            NSArray *cellsInPerRowWhenLayoutWithArray = [self cellsInPerRowWhenLayoutWithArray:items];
            [cellsCountArrayPerRowInSections addObject:cellsInPerRowWhenLayoutWithArray];
        }];
        _cellsCountArrayPerRowInSections = (NSArray *)cellsCountArrayPerRowInSections;
    }
    return _cellsCountArrayPerRowInSections;
}

-(NSMutableArray *)contentsArray{
    if (!_contentsArray) {
        _contentsArray = [NSMutableArray array];
    }
    return _contentsArray;
}

-(NSMutableArray *)tagContentArray{
    if (!_tagContentArray) {
        _tagContentArray = [NSMutableArray array];
    }
    return _tagContentArray;
}

//存储每组的内容
-(NSMutableArray *)sectionContentArray0{
    if (!_sectionContentArray0) {
        _sectionContentArray0 = [NSMutableArray array];
    }
    return _sectionContentArray0;
}

-(NSMutableArray *)sectionContentArray1{
    if (!_sectionContentArray1) {
        _sectionContentArray1 = [NSMutableArray array];
    }
    return _sectionContentArray1;
}

-(NSMutableArray *)sectionContentArray2{
    if (!_sectionContentArray2) {
        _sectionContentArray2 = [NSMutableArray array];
    }
    return _sectionContentArray2;
}

-(NSMutableArray *)sectionContentArray3{
    if (!_sectionContentArray3) {
        _sectionContentArray3 = [NSMutableArray array];
    }
    return _sectionContentArray3;
}

-(NSMutableArray *)sectionContentArray4{
    if (!_sectionContentArray4) {
        _sectionContentArray4 = [NSMutableArray array];
    }
    return _sectionContentArray4;
}

-(NSMutableArray *)sectionContentArray5{
    if (!_sectionContentArray5) {
        _sectionContentArray5 = [NSMutableArray array];
    }
    return _sectionContentArray5;
}

-(NSMutableArray *)sectionContentArray6{
    if (!_sectionContentArray6) {
        _sectionContentArray6 = [NSMutableArray array];
    }
    return _sectionContentArray6;
}

-(NSMutableArray *)sectionContentArray7{
    if (!_sectionContentArray7) {
        _sectionContentArray7 = [NSMutableArray array];
    }
    return _sectionContentArray7;
}

-(NSMutableArray *)sectionContentArray8{
    if (!_sectionContentArray8) {
        _sectionContentArray8 = [NSMutableArray array];
    }
    return _sectionContentArray8;
}

-(NSMutableArray *)sectionContentArray9{
    if (!_sectionContentArray9) {
        _sectionContentArray9 = [NSMutableArray array];
    }
    return _sectionContentArray9;
}

-(NSMutableArray *)filterCheckArray{
    if (!_filterCheckArray) {
        _filterCheckArray = [NSMutableArray array];
    }
    return _filterCheckArray;
}

-(NSMutableDictionary *)tagsDictionary{
    if (!_tagsDictionary) {
        _tagsDictionary = [NSMutableDictionary dictionary];
    }
    return _tagsDictionary;
}

//下载标签内容
- (void)downLoadTags {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [AFServer requestDataWithUrl:@"getFilterList" andDic:@{@"sessionId":kSessionId} completion:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            NSLog(@"dic = %@",dic);
            [self saveIntoArray:dic[@"response"]];
        }
        else{
            [OHCommon showWeakTips:[dic objectForKey:@"msg"] View:self];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [OHCommon showWeakTips:[NSString stringWithFormat:@"%@",error] View:self];

    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////* start 将后台数据转化为自己需要的格式 start *//////////////////////////////////////
//数据源
- (void) saveIntoArray:(NSDictionary *)dictionary {
    
    NSDictionary *contentDictionary = dictionary[@"filterValue"];
    //家庭成员
    NSMutableArray *familyCompose = [NSMutableArray arrayWithArray:contentDictionary[@"familyCompose"]];
    [self.tagContentArray addObject:familyCompose];
    
    // 家庭生活
    NSMutableArray *lifeCompose = [NSMutableArray arrayWithArray:contentDictionary[@"lifeCompose"]];
    [self.tagContentArray addObject:lifeCompose];
    
    //社区属性
    NSMutableArray *communityCompose = [NSMutableArray arrayWithArray:contentDictionary[@"communityCompose"]];
    [self.tagContentArray addObject:communityCompose];
    
    //基础设施
    NSMutableArray *infrastructureCompose = [NSMutableArray arrayWithArray:contentDictionary[@"infrastructureCompose"]];
    [self.tagContentArray addObject:infrastructureCompose];
    
    //社区配套
    NSMutableArray *supportComposes = [NSMutableArray arrayWithArray:contentDictionary[@"supportCompose"]];
    [self.tagContentArray addObject:supportComposes];
    
    //户型
    NSMutableArray *layoutCompose = [NSMutableArray arrayWithArray:contentDictionary[@"layoutCompose"]];
    [self.tagContentArray addObject:layoutCompose];
    
    //房屋类型
    NSMutableArray *houseTypeCompose = [NSMutableArray arrayWithArray:contentDictionary[@"houseTypeCompose"]];
    [self.tagContentArray addObject:houseTypeCompose];
    
    //建筑年代
    NSMutableArray *buildAgeCompose = [NSMutableArray arrayWithArray:contentDictionary[@"buildAgeCompose"]];
    [self.tagContentArray addObject:buildAgeCompose];
    
    //面积
    NSMutableArray *areaCompose = [NSMutableArray arrayWithArray:contentDictionary[@"areaCompose"]];
    [self.tagContentArray addObject:areaCompose];
    
    //房屋年限
    NSMutableArray *houseLifeCompose = [NSMutableArray arrayWithArray:contentDictionary[@"houseLifeCompose"]];
    [self.tagContentArray addObject:houseLifeCompose];
    
    if ([VALID_DICTIONARY(dictionary[@"filterCheck"]) count] != 0) {
        [self saveIntoFilterCheck:dictionary[@"filterCheck"]];
    }else {
         [self.collectionView reloadData];
    }
}

//已选择的标签
- (void) saveIntoFilterCheck:(NSDictionary *) dic {
    //家庭成员
    NSString *familyCompose = VALID_STRING(dic[@"familyCompose"]);
    if (familyCompose.length == 1) {
        NSArray *array = @[familyCompose];
        [self.filterCheckArray addObject:array];
    }else if (familyCompose.length > 1){
        NSArray *array = [familyCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }
    
    // 家庭生活
    NSString *lifeCompose = VALID_STRING(dic[@"lifeCompose"]);
    if (lifeCompose.length == 1) {
        NSArray *array = @[lifeCompose];
        [self.filterCheckArray addObject:array];
    }else if (lifeCompose.length > 1){
        NSArray *array = [lifeCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

    //社区属性
    NSString *communityCompose = VALID_STRING(dic[@"communityCompose"]);
    if (communityCompose.length == 1) {
        NSArray *array = @[communityCompose];
        [self.filterCheckArray addObject:array];
    }else if (communityCompose.length > 1){
        NSArray *array = [communityCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }
    
     //基础设施
    NSString *infrastructureCompose = VALID_STRING(dic[@"infrastructureCompose"]);
    if (infrastructureCompose.length == 1) {
        NSArray *array = @[infrastructureCompose];
        [self.filterCheckArray addObject:array];
    }else if (infrastructureCompose.length > 1){
        NSArray *array = [infrastructureCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

    //社区配套
    NSString *supportComposes = VALID_STRING(dic[@"supportComposes"]);
    if (supportComposes.length == 1) {
        NSArray *array = @[supportComposes];
        [self.filterCheckArray addObject:array];
    }else if (supportComposes.length > 1){
        NSArray *array = [supportComposes componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

    //户型
    NSString *layoutCompose = VALID_STRING(dic[@"layoutCompose"]);
    if (layoutCompose.length == 1) {
        NSArray *array = @[layoutCompose];
        [self.filterCheckArray addObject:array];
    }else if (layoutCompose.length > 1){
        NSArray *array = [layoutCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }
    
    //房屋类型
    NSString *houseTypeCompose = VALID_STRING(dic[@"houseTypeCompose"]);
    if (houseTypeCompose.length == 1) {
        NSArray *array = @[houseTypeCompose];
        [self.filterCheckArray addObject:array];
    }else if (houseTypeCompose.length > 1){
        NSArray *array = [houseTypeCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

    //建筑年代
    NSString *buildAgeCompose = VALID_STRING(dic[@"buildAgeCompose"]);
    if (buildAgeCompose.length == 1) {
        NSArray *array = @[buildAgeCompose];
        [self.filterCheckArray addObject:array];
    }else if (buildAgeCompose.length > 1){
        NSArray *array = [buildAgeCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

     //面积
    NSString *areaCompose = VALID_STRING(dic[@"areaCompose"]);
    if (areaCompose.length == 1) {
        NSArray *array = @[areaCompose];
        [self.filterCheckArray addObject:array];
    }else if (areaCompose.length > 1){
        NSArray *array = [areaCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

    //房屋年限
    NSString *houseLifeCompose = VALID_STRING(dic[@"houseLifeCompose"]);
    if (houseLifeCompose.length == 1) {
        NSArray *array = @[houseLifeCompose];
        [self.filterCheckArray addObject:array];
    }else if (houseLifeCompose.length > 1){
        NSArray *array = [houseLifeCompose componentsSeparatedByString:@","];
        [self.filterCheckArray addObject:array];
    }else {
        [self.filterCheckArray addObject:@[]];
    }

    [self judgeSelectedOrNot];
}

//重新构建数据 如果是选中的标签则在对应的字典内插入一的标志状态 states = 1:表示是已选中的标签 states = 0:表示该标签没有被选中
- (void) judgeSelectedOrNot {
    //第1组
    NSArray *array0 = self.tagContentArray[0];
    NSArray *selecetedArray0 = self.filterCheckArray[0];
    if (selecetedArray0.count != 0) {
       [selecetedArray0 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
           [array0 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
               if ([selectedCode integerValue] == [code[@"code"] integerValue]) {
                   [self.tagContentArray[0][index] setObject:@(1) forKey:@"states"];
                   [self.contentsArray addObject:self.tagContentArray[0][index][@"name"]];
                   [self.sectionContentArray0 addObject:self.tagContentArray[0][index][@"code"]];
               }else {
                   if ([self.tagContentArray[0][index][@"states"] integerValue] != 1) {
                       [self.tagContentArray[0][index] setObject:@(0) forKey:@"states"];
                   }
               }
           }];
       }];
    }
    
    //第2组
    NSArray *array1 = self.tagContentArray[1];
    NSArray *selecetedArray1 = self.filterCheckArray[1];
    if (selecetedArray1.count != 0) {
        [selecetedArray1 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            [array1 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue] == [code[@"code"] integerValue]) {
                    [self.tagContentArray[1][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[1][index][@"name"]];
                    [self.sectionContentArray1 addObject:self.tagContentArray[1][index][@"code"]];
                }else {
                    if ([self.tagContentArray[1][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[1][index] setObject:@(0) forKey:@"states"];
                    }
                    
                }
            }];
        }];
    }
    
    //第3组
    NSArray *array2 = self.tagContentArray[2];
    NSArray *selecetedArray2 = self.filterCheckArray[2];
    if (selecetedArray2.count != 0) {
        [selecetedArray2 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array2 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[2][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[2][index][@"name"]];
                    [self.sectionContentArray2 addObject:self.tagContentArray[2][index][@"code"]];
                }else {
                    if ([self.tagContentArray[2][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[2][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第4组
    NSArray *array3 = self.tagContentArray[3];
    NSArray *selecetedArray3 = self.filterCheckArray[3];
    if (selecetedArray3.count != 0) {
        [selecetedArray3 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array3 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[3][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[3][index][@"name"]];
                    [self.sectionContentArray3 addObject:self.tagContentArray[3][index][@"code"]];
                }else {
                    if ([self.tagContentArray[3][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[3][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第5组
    NSArray *array4 = self.tagContentArray[4];
    NSArray *selecetedArray4 = self.filterCheckArray[4];
    if (selecetedArray4.count != 0) {
        [selecetedArray4 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array4 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[4][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[4][index][@"name"]];
                    [self.sectionContentArray4 addObject:self.tagContentArray[4][index][@"code"]];
                }else {
                    if ([self.tagContentArray[4][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[4][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第6组
    NSArray *array5 = self.tagContentArray[5];
    NSArray *selecetedArray5 = self.filterCheckArray[5];
    if (selecetedArray5.count != 0) {
        [selecetedArray5 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array5 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[5][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[5][index][@"name"]];
                    [self.sectionContentArray5 addObject:self.tagContentArray[5][index][@"code"]];
                }else {
                    if ([self.tagContentArray[5][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[5][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第7组
    NSArray *array6 = self.tagContentArray[6];
    NSArray *selecetedArray6 = self.filterCheckArray[6];
    if (selecetedArray6.count != 0) {
        [selecetedArray6 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array6 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[6][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[6][index][@"name"]];
                    [self.sectionContentArray6 addObject:self.tagContentArray[6][index][@"code"]];
                }else {
                    if ([self.tagContentArray[6][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[6][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第8组
    NSArray *array7 = self.tagContentArray[7];
    NSArray *selecetedArray7 = self.filterCheckArray[7];
    if (selecetedArray7.count != 0) {
        [selecetedArray7 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array7 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[7][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[7][index][@"name"]];
                    [self.sectionContentArray7 addObject:self.tagContentArray[7][index][@"code"]];
                }else {
                    if ([self.tagContentArray[7][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[7][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第9组
    NSArray *array8 = self.tagContentArray[8];
    NSArray *selecetedArray8 = self.filterCheckArray[8];
    if (selecetedArray8.count != 0) {
        [selecetedArray8 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array8 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[8][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[8][index][@"name"]];
                    [self.sectionContentArray8 addObject:self.tagContentArray[8][index][@"code"]];
                }else {
                    if ([self.tagContentArray[8][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[8][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    //第10组
    NSArray *array9 = self.tagContentArray[9];
    NSArray *selecetedArray9 = self.filterCheckArray[9];
    if (selecetedArray9.count != 0) {
        [selecetedArray9 enumerateObjectsUsingBlock:^(id  _Nonnull selectedCode, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array9 enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger index, BOOL * _Nonnull stop) {
                if ([selectedCode integerValue]== [code[@"code"] integerValue]) {
                    [self.tagContentArray[9][index] setObject:@(1) forKey:@"states"];
                    [self.contentsArray addObject:self.tagContentArray[9][index][@"name"]];
                    [self.sectionContentArray9 addObject:self.tagContentArray[9][index][@"code"]];
                }else {
                    if ([self.tagContentArray[9][index][@"states"] integerValue] != 1) {
                        [self.tagContentArray[9][index] setObject:@(0) forKey:@"states"];
                    }
                }
            }];
        }];
    }
    
    [self.collectionView reloadData];
}

/////////////////////////////////////////////* end 将后台数据转化为自己需要的格式 end */////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//加载界面的动画效果
- (void) panAction:(UIPanGestureRecognizer *) pan {
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.75 animations:^{
            self.sideView.transform = CGAffineTransformMakeTranslation(OHScreenW - sideDistance, 0);
            [self upLoadTags];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

//设置底部的重置和确定按钮
- (void) createBottomButton {
    NSArray *titleArray = @[@"重置",@"确定"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] init];
        CGFloat btnY = OHScreenH - 50;
        CGFloat btnW = self.sideView.width / 2 ;
        CGFloat btnH = 50;
        CGFloat btnX = i * btnW ;
        
        [btn setTitleColor:[UIColor colorWithWhite:0.200 alpha:1.000] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        if (i == 0) {
            btn.layer.borderWidth = 1.0f;
            btn.layer.borderColor = [UIColor colorWithWhite:0.839 alpha:1.000].CGColor;
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithRed:1.000 green:0.467 blue:0.000 alpha:1.000]];
        }
        [self.sideView addSubview:btn];
    }

}

// 设置策划筛选界面
- (void) setupSideView {
    CGFloat sideViewWidth = OHScreenW - sideDistance;
    UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(OHScreenW, 0, sideViewWidth, OHScreenH)];
    sideView.backgroundColor = [UIColor whiteColor];
    [self addSubview:sideView];
    self.sideView = sideView;
    [UIView animateWithDuration:duration animations:^{
        sideView.transform = CGAffineTransformMakeTranslation(-sideViewWidth, 0);
    }];
}

//初始化 collectionView
- (void) setupCollectionView {
    CGRect collectionViewFrame = CGRectMake(0, 0, self.sideView.width, self.sideView.height);
    OHCollectionViewLeftAlignedLayout *layout = [[OHCollectionViewLeftAlignedLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[OHSideCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
//    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[OHSideHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OHSideFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewCellIdentifier];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [self.sideView addSubview:self.collectionView];

}

#pragma mark -  CYL Custom Method

//初始化 sectionHeaderView 的标题
- (void)initData {
    self.firstRowCellCountArray = nil;
//    self.dataSource = [NSArray arrayWithArray:[OHDataTool dataSource]];
    self.sectionTitleArray = [NSArray arrayWithArray:[OHDataTool dataSource]];
}

//对比返回 cell 的宽度
- (float)cellLimitWidth:(float)cellWidth limitMargin:(CGFloat)limitMargin isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (CGRectGetWidth(self.collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin - limitMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth;
        isLimitWidth ? isLimitWidth(YES, @(cellWidth)) : nil;
        return cellWidth;
    }
    isLimitWidth ? isLimitWidth(NO, @(cellWidth)) : nil;
    return cellWidth;
}

- (void)judgeMoreButtonShowWhenDefaultRowsCount:(NSUInteger)defaultRowsCount {
    [self.cellsCountArrayPerRowInSections enumerateObjectsUsingBlock:^(id  __nonnull cellsCountArrayPerRow, NSUInteger idx, BOOL * __nonnull stop) {
        NSUInteger __block sum = 0;
        [cellsCountArrayPerRow enumerateObjectsUsingBlock:^(NSNumber  * __nonnull cellsCount, NSUInteger cellsCountArrayPerRowIdx, BOOL * __nonnull stop) {
            if (cellsCountArrayPerRowIdx < defaultRowsCount) {
                sum += [cellsCount integerValue];
            } else {
                //|break;| Stop enumerating ;if wanna continue use |return| to Skip this object
                *stop = YES;
                return;
            }
        }];
        [self.firstRowCellCountArray replaceObjectAtIndex:idx withObject:@(sum)];
    }];
}

//计算每个数组应返回行数
- (NSUInteger)firstRowCellCountWithArray:(NSArray *)array {
    CGFloat contentViewWidth = CGRectGetWidth(self.collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin;
    NSUInteger firstRowCellCount = 0;
    float currentCellWidthSum = 0;
    float currentCellSpace = 0;
    for (int i = 0; i < array.count; i++) {
        NSString *text = array[i][@"name"];
        float cellWidth = [self collectionCellWidthText:text content:array[i]];
        if (cellWidth >= contentViewWidth) {
            return i == 0? 1 : firstRowCellCount;
        } else {
            currentCellWidthSum += cellWidth;
            if (i == 0) {
                firstRowCellCount++;
                continue;
            }
            currentCellSpace = (contentViewWidth - currentCellWidthSum) / firstRowCellCount;
            if (currentCellSpace <= kCollectionViewCellsHorizonMargin) {
                return firstRowCellCount;
            } else {
                firstRowCellCount++;
            }
        }
    }
    return firstRowCellCount;
}

//cell在每一行的布局与数组
- (NSMutableArray *)cellsInPerRowWhenLayoutWithArray:(NSMutableArray *)array {
    __block NSUInteger secondRowCellCount = 0;
    NSMutableArray *items = [NSMutableArray arrayWithArray:array];
    NSUInteger firstRowCount = [self firstRowCellCountWithArray:items];
    NSMutableArray *cellCount = [NSMutableArray arrayWithObject:@(firstRowCount)];
    for (NSUInteger index = 0; index < [array count]; index++) {
        NSUInteger firstRowCount = [self firstRowCellCountWithArray:items];
        if (items.count != firstRowCount) {
            NSRange range = NSMakeRange(0, firstRowCount);
            [items removeObjectsInRange:range];
            NSUInteger secondRowCount = [self firstRowCellCountWithArray:items];
            secondRowCellCount = secondRowCount;
            [cellCount addObject:@(secondRowCount)];
        } else {
            return cellCount;
        }
    }
    return cellCount;
}

//根据文字和图片来计算cell的宽度
- (float)collectionCellWidthText:(NSString *)text content:(NSDictionary *)content {
    float cellWidth;
    CGSize size = [text sizeWithAttributes: @{NSFontAttributeName:[OHFont systemFontOfSize:14 * kAdaptationCoefficient]}];
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
    cellWidth = [self cellLimitWidth:cellWidth limitMargin:0 isLimitWidth:nil];

    return cellWidth;
}

//更新高度
- (void)updateViewHeight {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView.collectionViewLayout prepareLayout];
}

#pragma mark - UICollectionViewDataSource Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.tagContentArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *items = [NSArray arrayWithArray:self.tagContentArray[section]];
    for (NSNumber *i in self.expandSectionArray) {
        if (section == [i integerValue]) {
            return [items count];
        }
    }
    return [self.firstRowCellCountArray[section] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OHSideCollectionViewCell *cell = (OHSideCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.tagContentArray[indexPath.section]];
    NSString *text = items[indexPath.row][@"name"];
    cell.contentString = text;
    
    cell.button.indexPath = indexPath;

    NSNumber *code = self.tagContentArray[indexPath.section][indexPath.item][@"states"];
    if ([code integerValue] == 1) {
        cell.button.selected = YES;
    }else {
        cell.button.selected = NO;
    }

    [cell.button addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)itemButtonClicked:(OHIndexPathButton *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.indexPath.row inSection:button.indexPath.section];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate Method
//二级菜单选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OHSideCollectionViewCell *cell = (OHSideCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    //数组中没有这个字符串
    if (![self.contentsArray containsObject:cell.button.currentTitle]) {
        if (cell.button.selected) {
            cell.button.selected = NO;
            [self deleteContentTag:indexPath.section withCode:self.tagContentArray[indexPath.section][indexPath.row][@"code"] withItem:indexPath.item];
        }else {
            cell.button.selected = YES;
            [self saveContentTag:indexPath.section withCode:self.tagContentArray[indexPath.section][indexPath.row][@"code"] withItem:indexPath.item];
        }
        [self.contentsArray addObject:cell.button.currentTitle];
       
    }else {//数组中有这个字符串
        cell.button.selected = NO;
        [self.contentsArray removeObject:cell.button.currentTitle];
        [ self deleteContentTag:indexPath.section withCode:self.tagContentArray[indexPath.section][indexPath.row][@"code"] withItem:indexPath.item];
    }
    
    
}

//保存每组选中的标签
- (void) saveContentTag:(NSInteger) section withCode:(NSString *) code withItem:(NSInteger) item {
    switch (section) {
        case 0:{
            [self.sectionContentArray0 addObject:code];
            [self.tagContentArray[0][item] setValue:@(1) forKey:@"states"];
        }
        break;
        case 1:{
            [self.sectionContentArray1 addObject:code];
            [self.tagContentArray[1][item] setValue:@(1) forKey:@"states"];
        }
        break;
        case 2:{
             [self.sectionContentArray2 addObject:code];
             [self.tagContentArray[2][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 3:{
             [self.sectionContentArray3 addObject:code];
             [self.tagContentArray[3][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 4:{
            [self.sectionContentArray4 addObject:code];
            [self.tagContentArray[4][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 5:{
            [self.sectionContentArray5 addObject:code];
            [self.tagContentArray[5][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 6:{
            [self.sectionContentArray6 addObject:code];
            [self.tagContentArray[6][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 7:{
            [self.sectionContentArray7 addObject:code];
            [self.tagContentArray[7][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 8:{
             [self.sectionContentArray8 addObject:code];
             [self.tagContentArray[8][item] setValue:@(1) forKey:@"states"];
        }
            break;
        case 9:{
             [self.sectionContentArray9 addObject:code];
             [self.tagContentArray[9][item] setValue:@(1) forKey:@"states"];
        }
            break;
        default:
            break;
    }
}

//删除每组选中的标签
- (void) deleteContentTag:(NSInteger) section withCode:(NSString *) code withItem:(NSInteger) item {
    switch (section) {
        case 0:{
            [self.sectionContentArray0  removeObject:code];
            [self.tagContentArray[0][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 1:{
            [self.sectionContentArray1 removeObject:code];
            [self.tagContentArray[1][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 2:{
            [self.sectionContentArray2 removeObject:code];
            [self.tagContentArray[2][item] setValue:@(0) forKey:@"states"];
            
        }
            break;
        case 3:{
            [self.sectionContentArray3 removeObject:code];
            [self.tagContentArray[3][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 4:{
            [self.sectionContentArray4 removeObject:code];
            [self.tagContentArray[4][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 5:{
            [self.sectionContentArray5 removeObject:code];
            [self.tagContentArray[5][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 6:{
            [self.sectionContentArray6 removeObject:code];
            [self.tagContentArray[6][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 7:{
            [self.sectionContentArray7 removeObject:code];
            [self.tagContentArray[7][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 8:{
            [self.sectionContentArray8 removeObject:code];
            [self.tagContentArray[8][item] setValue:@(0) forKey:@"states"];
        }
            break;
        case 9:{
            [self.sectionContentArray9 removeObject:code];
            [self.tagContentArray[9][item] setValue:@(0) forKey:@"states"];
        }
            break;
        default:
            break;
    }
}

//字符转拼接
//- (NSString *) joiningTogether:(NSArray *)array{
//    //对字符串进行拼接
//    NSString *tagString = array[0];
//    for (int i = 1;i < array.count;i++) {
//        tagString = [tagString stringByAppendingString:@","];
//        tagString = [tagString stringByAppendingString:array[i]];
//    }
//    return tagString;
//}

//组头/组尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        OHSideHeaderView *sideHeaderView =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:kHeaderViewCellIdentifier
                                                  forIndexPath:indexPath];
        sideHeaderView.delegate = self;
        sideHeaderView.titleButton.tag = indexPath.section;
        sideHeaderView.moreButton.tag = indexPath.section;
        sideHeaderView.moreButton.selected = NO;
        sideHeaderView.title = [self.sectionTitleArray[indexPath.section] objectForKey:@"Type"];

        for (NSNumber *i in self.expandSectionArray) {
            if (indexPath.section == [i integerValue]) {
                sideHeaderView.moreButton.selected = YES;
            }
        }
        return sideHeaderView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        OHSideFooterView *sideFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewCellIdentifier forIndexPath:indexPath];
        if (indexPath.section == self.tagContentArray.count - 1) {
            sideFooterView.bgView.hidden = YES;
        }else {
            sideFooterView.bgView.hidden = NO;
        }
        return sideFooterView;
    }
    return nil;
}

//重置和确定按钮的响应事件
- (void) btnClick:(UIButton *) btn {
    if ([btn.currentTitle isEqualToString:@"重置"]) {
        [self.contentsArray removeAllObjects];
        [self.sectionContentArray0 removeAllObjects];
        [self.sectionContentArray1 removeAllObjects];
        [self.sectionContentArray2 removeAllObjects];
        [self.sectionContentArray3 removeAllObjects];
        [self.sectionContentArray4 removeAllObjects];
        [self.sectionContentArray5 removeAllObjects];
        [self.sectionContentArray6 removeAllObjects];
        [self.sectionContentArray7 removeAllObjects];
        [self.sectionContentArray8 removeAllObjects];
        [self.sectionContentArray9 removeAllObjects];
        
        [self.tagContentArray enumerateObjectsUsingBlock:^(NSArray  *_Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
            [array enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([dic[@"states"] integerValue] == 1) {
                    [dic setValue:@(0) forKey:@"states"];
                }
            }];
        }];
       [self.collectionView reloadData];
        
    }else{
        [self upLoadTags];
    }
}

//将选取的标签进行拼接然后再上传标签
- (void) upLoadTags {
    if (self.sectionContentArray0.count != 0) {
        self.familyCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray0[0]];
        if (self.sectionContentArray0.count >= 2) {
            for (int i = 1; i < self.sectionContentArray0.count; i++) {
                self.familyCompose  = [self.familyCompose  stringByAppendingString:@","];
                self.familyCompose  = [self.familyCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray0[i]]];
            }
        }
        [self.tagsDictionary setObject:self.familyCompose forKey:@"familyCompose"];
    }
    if (self.sectionContentArray1.count != 0) {
        self.lifeCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray1[0]];
        if (self.sectionContentArray1.count >= 2) {
            for (int i = 1; i < self.sectionContentArray1.count; i++) {
                self.lifeCompose  = [self.lifeCompose  stringByAppendingString:@","];
                self.lifeCompose  = [self.lifeCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray1[i]]];
            }
        }
        [self.tagsDictionary setObject:self.lifeCompose forKey:@"lifeCompose"];
    }
    if (self.sectionContentArray2.count != 0) {
        self.communityCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray2[0]];
        if (self.sectionContentArray2.count >= 2) {
            for (int i = 1; i < self.sectionContentArray2.count; i++) {
                self.communityCompose  = [self.communityCompose  stringByAppendingString:@","];
                self.communityCompose  = [self.communityCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray2[i]]];
            }
        }
        [self.tagsDictionary setObject:self.communityCompose forKey:@"communityCompose"];
    }
    if (self.sectionContentArray3.count != 0) {
        self.infrastructureCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray3[0]];
        if (self.sectionContentArray3.count >= 2) {
            for (int i = 1; i < self.sectionContentArray3.count; i++) {
                self.infrastructureCompose  = [self.infrastructureCompose  stringByAppendingString:@","];
                self.infrastructureCompose  = [self.infrastructureCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray3[i]]];
            }
        }
        [self.tagsDictionary setObject:self.infrastructureCompose forKey:@"infrastructureCompose"];
    }
    if (self.sectionContentArray4.count != 0) {
        self.supportCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray4[0]];
        if (self.sectionContentArray4.count >= 2) {
            for (int i = 1; i < self.sectionContentArray4.count; i++) {
                self.supportCompose  = [self.supportCompose  stringByAppendingString:@","];
                self.supportCompose  = [self.supportCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray4[i]]];
            }
        }
        [self.tagsDictionary setObject:self.supportCompose forKey:@"supportComposes"];
    }
    if (self.sectionContentArray5.count != 0) {
        self.layoutCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray5[0]];
        if (self.sectionContentArray5.count >= 2) {
            for (int i = 1; i < self.sectionContentArray5.count; i++) {
                self.layoutCompose  = [self.layoutCompose  stringByAppendingString:@","];
                self.layoutCompose  = [self.layoutCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray5[i]]];
            }
        }
        [self.tagsDictionary setObject:self.layoutCompose forKey:@"layoutCompose"];
    }
    if (self.sectionContentArray6.count != 0) {
        self.houseTypeCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray6[0]];
        if (self.sectionContentArray6.count >= 2) {
            for (int i = 1; i < self.sectionContentArray6.count; i++) {
                self.houseTypeCompose  = [self.houseTypeCompose  stringByAppendingString:@","];
                self.houseTypeCompose  = [self.houseTypeCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray6[i]]];
            }
        }
        [self.tagsDictionary setObject:self.houseTypeCompose forKey:@"houseTypeCompose"];
    }
    if (self.sectionContentArray7.count != 0) {
        self.buildAgeCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray7[0]];
        if (self.sectionContentArray7.count >= 2) {
            for (int i = 1; i < self.sectionContentArray7.count; i++) {
                self.buildAgeCompose  = [self.buildAgeCompose  stringByAppendingString:@","];
                self.buildAgeCompose  = [self.buildAgeCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray7[i]]];
            }
        }
        [self.tagsDictionary setObject:self.buildAgeCompose forKey:@"buildAgeCompose"];
    }
    if (self.sectionContentArray8.count != 0) {
        self.areaCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray8[0]];
        if (self.sectionContentArray8.count >= 2) {
            for (int i = 1; i < self.sectionContentArray8.count; i++) {
                self.areaCompose  = [self.areaCompose  stringByAppendingString:@","];
                self.areaCompose  = [self.areaCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray8[i]]];
            }
        }
        [self.tagsDictionary setObject:self.areaCompose forKey:@"areaCompose"];
    }
    if (self.sectionContentArray9.count != 0) {
        self.houseLifeCompose = [ NSString stringWithFormat:@"%@",self.sectionContentArray9[0]];
        if (self.sectionContentArray9.count >= 2) {
            for (int i = 1; i < self.sectionContentArray9.count; i++) {
                self.houseLifeCompose  = [self.houseLifeCompose  stringByAppendingString:@","];
                self.houseLifeCompose  = [self.houseLifeCompose  stringByAppendingString:[NSString stringWithFormat:@"%@",self.sectionContentArray9[i]]];
            }
        }
        [self.tagsDictionary setObject:self.houseLifeCompose forKey:@"houseLifeCompose"];
    }

    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [AFServer requestDataWithUrl:@"saveChooseFilter" andDic:@{@"sessionId":kSessionId,@"filterCheck":self.tagsDictionary} completion:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [OHCommon showWeakTips:dic[@"msg"] View:self];
         !self.completed ? :self.completed();

        [UIView animateWithDuration:0.75 animations:^{
            self.sideView.transform = CGAffineTransformMakeTranslation(OHScreenW - sideDistance, 0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self animated:YES];
         [OHCommon showWeakTips:[NSString stringWithFormat:@"%@",error] View:self];
    }];
}



#pragma mark - FilterHeaderViewDelegateMethod Method

- (void)OHSideHeaderViewMoreButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.expandSectionArray addObject:@(sender.tag)];
    } else {
        [self.expandSectionArray removeObject:@(sender.tag)];
    }
    
    //无动画效果
    __weak __typeof(self) weakSelf = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:sender.tag];
    [UIView performWithoutAnimation:^{
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
    
    //有动画效果
//       [self.collectionView performBatchUpdates:^{
//        __strong typeof(self) strongSelf = weakSelf;
//        NSIndexSet *section = [NSIndexSet indexSetWithIndex:sender.tag];
//        [strongSelf.collectionView reloadSections:section];
//    } completion:^(BOOL finished) {
//       __strong typeof(self) strongSelf = weakSelf;
//        // [strongSelf updateViewHeight];
//    }];
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 1.0 * (self.sideView.width - (kCollectionViewCellsHorizonMargin  + kCollectionViewToLeftMargin) * kAdaptationCoefficient * (columnsOfEachrow - 1)) / columnsOfEachrow ;
    
    
//    CGFloat itemWidth = 1.0 * (self.sideView.width - 54) / columnsOfEachrow;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellsHorizonMargin * kAdaptationCoefficient;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellsVerticalMargin * kAdaptationCoefficient;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(OHScreenW - sideDistance * kAdaptationCoefficient, HeaderViewHeight * kAdaptationCoefficient);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2 || section == 5 ) {
        return CGSizeMake(OHScreenW, FooterViewHeight * kAdaptationCoefficient);
    }else if (section == self.tagContentArray.count - 1) {
        return CGSizeMake(OHScreenW, 55 * kAdaptationCoefficient);
    }
    return CGSizeMake(OHScreenW - sideDistance * kAdaptationCoefficient, 0);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCollectionViewToTopMargin * kAdaptationCoefficient, kCollectionViewToLeftMargin * kAdaptationCoefficient, kCollectionViewToBottomtMargin * kAdaptationCoefficient, kCollectionViewToRightMargin * kAdaptationCoefficient);
}


#pragma mark - 点击移除 sideView
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.sideView.transform = CGAffineTransformMakeTranslation(OHScreenW, 0);
        [self upLoadTags];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
