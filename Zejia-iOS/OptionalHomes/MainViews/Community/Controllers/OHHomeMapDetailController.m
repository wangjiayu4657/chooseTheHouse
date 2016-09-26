//
//  OHHomeMapDetailController.m
//  OptionalHome
//
//  Created by Dr_liu on 16/8/9.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHHomeMapDetailController.h"
#import "BaiduMapAPI_Map/BMKMapView.h"
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

@interface OHHomeMapDetailController () <BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation OHHomeMapDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    self.titleStr = @"社区详情地图";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    [super viewDidLoad];
    self.view.backgroundColor = OHColor(20, 230, 230, 1);
    
    [self createMapView];
}
- (void) viewDidAppear:(BOOL)animated {
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.latitude floatValue];
    coor.longitude = [self.longitude floatValue];
    annotation.coordinate = coor;
    annotation.title = self.communityName;
    [_mapView addAnnotation:annotation];
    
    // 让地图挪动到对应的位置(经纬度交叉处)
    [_mapView setCenterCoordinate:coor animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;    // 不用时，置nil
}

#pragma mark - 创建MapView
- (void)createMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH)];
    [self.view addSubview:_mapView];
    _mapView.mapType = BMKMapTypeStandard; // 地图类型
    _mapView.trafficEnabled = NO;          // 显示交通
    _mapView.zoomLevel = 19.0;             // 设置地图的比例尺级别
    _mapView.showMapScaleBar = NO;         // 隐藏比例尺
    _mapView.delegate = self;
}

#pragma mark - 设置大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"map_sign_icon"];   // 设置大头针的图片
        return newAnnotationView;
    }
    return nil;
}

@end


