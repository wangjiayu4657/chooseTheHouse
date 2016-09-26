//
//  OHDetailMapController.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/8.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHDetailMapController.h"
#import "BaiduMapAPI_Map/BMKMapView.h"
#import "OHCommPeripheryModel.h"
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKCircle.h>
#import <BaiduMapAPI_Map/BMKCircleView.h>
#import "OHPeripheryAnnotation.h"

#define kFood @"food"
#define kVegetable @"vegetable"
#define kPark @"park"
#define kMovie @"movie"
#define kSchool @"school"
#define kPreSchool @"preSchool"
#define kMarket @"market"
#define kCstore @"cstore"
#define kBusiness @"business"
#define kHospital @"hospital"

@interface OHDetailMapController ()<BMKMapViewDelegate>
{
    NSMutableArray *_responseArr;
    UIButton *_selectedBtn;         //  标记选中的button
    NSMutableArray *_filterArr;
    BMKMapView *_mapView;
    NSMutableArray *_allDataArray;  //  存放周边生活信息的数组
    NSDictionary *_annoViewImgsNameDic;
    
    
    NSMutableArray *_foodList;
    NSMutableArray *_playList;
    NSMutableArray *_schoolList;
    NSMutableArray *_buyList;
    NSMutableArray *_hospitalList;
}
@end

@implementation OHDetailMapController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    
    self.titleStr = @"周边信息地图";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    self.view.backgroundColor = OHColor(20, 230, 230, 1);
    
    [super viewDidLoad];
    
    [self createMapView];
    
    //全部类型->吃
    if (_type == 0 || _type == AllPeripheryType) {
        _type = FoodPeripheryType;
    }
    _annoViewImgsNameDic = @{
                             kFood:@"foodList_icon",
                             kVegetable:@"vegetableList_icon",
                             kPark:@"parkList_icon",
                             kMarket:@"marketList_icon",
                             kCstore:@"marketList_icon",
                             kMovie:@"movieList_icon",
                             kBusiness:@"businessList_icon",
                             kHospital:@"hospitalList_icon",
                             kSchool:@"schoolList_icon",
                             kPreSchool:@"schoolList_icon"
                             };
    // 请求数据
    [self configData];
    
    // 创建底部的按钮选项
    [self createButtons];
}

#pragma mark - 创建MapView
- (void)createMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH-kNaviHeight)];
    CLLocationCoordinate2D location = {self.model.latitude.doubleValue, self.model.longitude.doubleValue};
    BMKCoordinateRegion region;
    region.center = location;
    region.span.latitudeDelta = 0.068;
    region.span.longitudeDelta = 0.068;
    [_mapView setRegion:region animated:YES];
    
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 17.0;
    _mapView.trafficEnabled = NO;
    _mapView.showMapScaleBar = NO;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc]init];
    ann.coordinate = location;
    ann.title = @"当前位置";
    [_mapView addAnnotation:ann];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

#pragma mark - 创建底部的按钮选项
- (void)createButtons {
    // 准备底部按钮的图片
    NSArray *imageArray = @[
                            @"map_eat",
                            @"map_play",
                            @"map_school",
                            @"map_shop",
                            @"map_hospital"
                            ];
    NSArray *titleArray = @[
                            @"吃",
                            @"玩",
                            @"学",
                            @"买",
                            @"医"
                            ];
    //_default_icon _selected_icon
    // 创建背景view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, OHScreenH - 24 - 48, OHScreenW - 24, 48)];
    bgView.layer.cornerRadius = 24;
    bgView.backgroundColor = OHColor(0, 0, 0, 0.7);
    [self.view addSubview:bgView];
    
    // 创建button
    CGFloat marginX = (bgView.frame.size.width - 60-30*5) / 4;
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(30 + (30 + marginX) * i, 5, 30, 38);
        NSString *norImgName = [imageArray[i]stringByAppendingString:@"_default_icon"];
        NSString *selectedImgName = [imageArray[i] stringByAppendingString:@"_selected_icon"];
        [button setImage:[[UIImage imageNamed:norImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:selectedImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(22, -29, 0, 0);
        button.titleLabel.font = [OHFont systemFontOfSize:12*kAdaptationCoefficient];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:OHColor(255, 255, 255, 1) forState:UIControlStateNormal];
        button.tintColor = [UIColor clearColor];
        [button setTitleColor:OHColor(251, 229, 88, 1.0) forState:UIControlStateSelected];
        [bgView addSubview:button];
        
        //使用枚举值标记tag
        button.tag = FoodPeripheryType+i;
        
        if (_type == button.tag) {
            _selectedBtn = button;
            button.selected = YES;
        }
        
        [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 底部按钮点击事件
- (void)changeType:(UIButton *)btn
{
    if (_selectedBtn == btn) {
        return;
    }
    
    //改变按钮样式
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    
    //显示对应的标注
    [self showAnnotationViewWithType:btn.tag];
}

#pragma mark - 显示类型对应的标注视图
- (void)showAnnotationViewWithType:(PeripheryType)type
{
    NSArray *filterArr = [self getTypesWithIndex:type];
    if (filterArr.count) {
        [self filterResponseDataWithTypes:filterArr];
    }
    else{
        [_mapView removeAnnotations:_mapView.annotations];
        [OHCommon showWeakTips:@"附近没有符合条件的搜索结果" View:self.view];
    }
}

#pragma mark - 根据按钮索引返回即将要显示的标注视图类型
- (NSArray *)getTypesWithIndex:(PeripheryType)type
{
    switch (type) {
        case FoodPeripheryType:
            return _foodList;
            break;
        case PlayPeripheryType:
            return _playList;
            break;
        case StudyPeripheryType:
            return _schoolList;
            break;
        case BuyPeripheryType:
            return _buyList;
            break;
        case HospitalPeripheryType:
            return _hospitalList;
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - 过滤符合条件的模型，添加标注
- (void)filterResponseDataWithTypes:(NSArray *)filterArr
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (OHCommPeripheryModel *model in filterArr) {
        OHPeripheryAnnotation *anno = [[OHPeripheryAnnotation alloc]init];
        anno.title = model.name;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(model.latitude.doubleValue,model.longitude.doubleValue);
        anno.coordinate = location;
        anno.typeName = model.type;
        [_mapView addAnnotation:anno];
    }
    CLLocationCoordinate2D location = {self.model.latitude.doubleValue, self.model.longitude.doubleValue};
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc]init];
    ann.coordinate = location;
    ann.title = @"当前位置";
    [_mapView addAnnotation:ann];
}

#pragma mark - 根据type获取对应图片名称
- (UIImage *)getImageWithTypeName:(NSString *)type
{
    NSString *imgName = _annoViewImgsNameDic[type];
    return [UIImage imageNamed:imgName];
}

#pragma mark - 请求数据
- (void)configData {
    [AFServer requestDataWithUrl:@"getCommPeriphery" andDic:@{@"sessionId":kSessionId, @"communityId":self.communityId}
                      completion:^(NSDictionary *dic) {
                          
                          NSArray *businessList = dic[@"response"][@"businessList"];
                          NSArray *foodList = dic[@"response"][@"foodList"];
                          NSArray *movieList = dic[@"response"][@"movieList"];
                          NSArray *hospitalList = dic[@"response"][@"hospitalList"];
                          NSArray *marketList = dic[@"response"][@"marketList"];
                          NSArray *vegetableList = dic[@"response"][@"vegetableList"];
                          NSArray *schoolList = dic[@"response"][@"schoolList"];
                          NSArray *parkList = dic[@"response"][@"parkList"];
                          
                          if (!_foodList) {
                              _foodList = [NSMutableArray array];
                          }
                          if (!_playList) {
                              _playList = [NSMutableArray array];
                          }
                          if (!_schoolList) {
                              _schoolList = [NSMutableArray array];
                          }
                          if (!_buyList) {
                              _buyList = [NSMutableArray array];
                          }
                          if (!_hospitalList) {
                              _hospitalList = [NSMutableArray array];
                          }
                          //吃
                          for (NSDictionary* dic in  [foodList arrayByAddingObjectsFromArray:vegetableList]) {
                              OHCommPeripheryModel *model = [OHCommPeripheryModel mj_objectWithKeyValues:dic context:nil];
                              [_foodList addObject:model];
                          }
                          //玩
                          for (NSDictionary* dic in  [movieList arrayByAddingObjectsFromArray:parkList]) {
                              OHCommPeripheryModel *model = [OHCommPeripheryModel mj_objectWithKeyValues:dic context:nil];
                              [_playList addObject:model];
                          }
                          //学
                          for (NSDictionary* dic in  schoolList) {
                              OHCommPeripheryModel *model = [OHCommPeripheryModel mj_objectWithKeyValues:dic context:nil];
                              [_schoolList addObject:model];
                          }
                          //买
                          for (NSDictionary* dic in  [marketList arrayByAddingObjectsFromArray:businessList]) {
                              OHCommPeripheryModel *model = [OHCommPeripheryModel mj_objectWithKeyValues:dic context:nil];
                              [_buyList addObject:model];
                          }
                          //医
                          for (NSDictionary* dic in  hospitalList) {
                              OHCommPeripheryModel *model = [OHCommPeripheryModel mj_objectWithKeyValues:dic context:nil];
                              [_hospitalList addObject:model];
                          }
                          //数据获取完毕显示当前选中类型对应的标注视图
                          [self showAnnotationViewWithType:_type];
                          
                      } failure:^(NSError *error) {
                          [OHCommon showWeakTips:@"服务器君已罢工，请稍后再试" View:self.view];
                      }];
}

#pragma mark - MapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[OHPeripheryAnnotation class]]) {
        static NSString *reuseIde = @"PeriAnnotation";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIde];
        if (!newAnnotationView) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIde];
            newAnnotationView.canShowCallout = YES;
        }
        newAnnotationView.annotation = annotation;
        newAnnotationView.image = [self getImageWithTypeName:[(OHPeripheryAnnotation*)annotation typeName]];
        return newAnnotationView;
    }
    else
    {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"CurLocation"];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"map_sign_icon"];
        return annotationView;
    }
}

@end



