//
//  OHSettingPlaceController.m
//  OptionalHome
//
//  Created by Dr_liu on 16/7/28.
//  Copyright © 2016年 haili. All rights reserved.
//

#define KcenterButtonX  (OHScreenW-30)/2
#define KcenterButtonY  (OHScreenH-30-kNaviHeight)/2

#import "OHSettingPlaceController.h"
#import "BaiduMapAPI_Map/BMKMapView.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "OHTextField.h"
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKSuggestionSearch.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

@interface OHSettingPlaceController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate,
UITextFieldDelegate, BMKPoiSearchDelegate, BMKSuggestionSearchDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    NSString  *_lat;          // 前页面传过来的
    NSString  *_lon;
    NSString  *_latitude;
    NSString  *_longitude;    // 建议搜过结果
    
    BOOL _isLegalTF1;         // textfield标记
    BOOL _isLegalTF2;
    BOOL _isClickedRightBtn;  // 保存按钮的标记
    
}

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;      // 定位搜索
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch1;    // geo搜索1
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch2;    // geo搜索2
@property (nonatomic, strong) BMKSuggestionSearch *suggestSearch;  // 在线建议查询搜索

@property (nonatomic, strong) OHTextField *textField1;      // 工作地址输入框1
@property (nonatomic, strong) OHTextField *textField2;      // 工作地址输入框2
@property (nonatomic, strong) UIButton *userLocationButton; // 定位到当前位置
@property (nonatomic, strong) UIButton *centerButton;       // 中心点button
@property (nonatomic, assign) CLLocationCoordinate2D cordinate; // 地图移动后定位的坐标

@property (nonatomic, strong) NSArray *keyListArray;        // 建议查询返回的数据
@property (nonatomic, strong) NSArray *ptListArray;         // pt列表，成员是：封装成NSValue的CLLocationCoordinate2D

@property (nonatomic, strong) UITableView *suggestTableView;// 用来展示建议查询结果
@property (nonatomic, strong) UIView *maskView;             // 点击搜索框弹出的蒙板
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation OHSettingPlaceController

- (void)viewDidLoad {
    
    //判断字典内部的值
    if([self.workDictionary[@"1"] length] || [self.lifeDictionary[@"1"] length])
    {
        _isLegalTF1 = YES;
    }
    
    if([self.workDictionary[@"2"] length] || [self.lifeDictionary[@"2"] length])
    {
        _isLegalTF2 = YES;
    }
    
    // 发出通知检测textfield文字的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.titleStr = [NSString stringWithFormat:@"设置%@", _titleString];
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    self.rightButtonStatus = rightButtonWithTitle;
    self.rightCustomButtonTitle = @"保存";
    [super viewDidLoad];
    
    [self createMapView];
    
    [self createTextField];
    
    [self createLocationAndCenterButton];
}

- (void)createLocationAndCenterButton {
    _userLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _userLocationButton.frame = CGRectMake(OHScreenW - 45 - 24, OHScreenH - 60 - 45, 45, 45);
    [_userLocationButton setImage:[UIImage imageNamed:@"map_home_icon"] forState:UIControlStateNormal];
    [_userLocationButton addTarget:self action:@selector(userLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userLocationButton];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.frame = CGRectMake(KcenterButtonX, KcenterButtonY, 30, 30);
    [self.centerButton setImage:[UIImage imageNamed:@"map_lsign_icon"] forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.centerButton];
}

#pragma mark - 创建MapView
- (void)createMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kNaviHeight, OHScreenW, OHScreenH - kNaviHeight)];
    [self.view addSubview:_mapView];
    _mapView.mapType = BMKMapTypeStandard; // 地图类型
    _mapView.trafficEnabled = NO;          // 显示交通
    _mapView.zoomLevel = 18.0;             // 设置地图的比例尺级别
    _mapView.showMapScaleBar = NO;         // 隐藏比例尺
    
    _geocodesearch1 = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch2 = [[BMKGeoCodeSearch alloc] init];
    //初始化检索对象
    _suggestSearch =[[BMKSuggestionSearch alloc]init];
    
    //初始化BMKLocationService，定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_mapView addGestureRecognizer:tap];
    
    _mapView.showsUserLocation = NO; //先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态
    _mapView.showsUserLocation = NO; //显示定位图层
}

#pragma mark - 创建输入框textField
- (void)createTextField {
    CGFloat X = 24;
    CGFloat marginY = 24;
    CGFloat With = OHScreenW -  X * 2;
    CGFloat Height = 44;
    
    self.textField1 = [[OHTextField alloc] initWithFrame:CGRectMake(X, kNaviHeight + marginY, With, Height) placeHolder:@"请输入第一个地点" tag:10 delegate:self];
    [self.view addSubview:self.textField1];
    
    self.textField2 = [[OHTextField alloc] initWithFrame:CGRectMake(X, kNaviHeight + marginY + Height - 1, With, Height) placeHolder:@"请输入第二个地点" tag:11 delegate:self];
    [self.view addSubview:self.textField2];
    
    if ([_titleString isEqualToString:@"工作区域"]) {
        self.textField1.text = [self.workDictionary valueForKey:@"1"];
        self.textField2.text = [self.workDictionary valueForKey:@"2"];
        
        // textField1地址对应的坐标
        _lat = [self.workDictionary objectForKey:@"lat"];
        _lon = [self.workDictionary objectForKey:@"lon"];
        
        // textFiel21地址对应的坐标
        _latitude = [self.workDictionary objectForKey:@"latitude"];
        _longitude = [self.workDictionary objectForKey:@"longitude"];
    } else {
        self.textField1.text = [self.lifeDictionary valueForKey:@"1"];
        self.textField2.text = [self.lifeDictionary valueForKey:@"2"];
        
        _lat = [self.lifeDictionary objectForKey:@"lat"];
        _lon = [self.lifeDictionary objectForKey:@"lon"];
        _latitude = [self.lifeDictionary objectForKey:@"latitude"];
        _longitude = [self.lifeDictionary objectForKey:@"longitude"];
    }
    
    if (_textField1.text.length > 0) {
        // 定位到指定位置
        CLLocationCoordinate2D coor;
        coor.latitude = [_lat floatValue];
        coor.longitude = [_lon floatValue];
        
        // 让地图挪动到对应的位置(经纬度交叉处)
        [_mapView setCenterCoordinate:coor animated:YES];
        
    } else {
        // 定位到当前位置
        [self userLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;   // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch1.delegate = self;
    _geocodesearch2.delegate = self;
    _suggestSearch.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;    // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch1.delegate = nil;
    _geocodesearch2.delegate = nil;
    _suggestSearch.delegate = nil;
}

#pragma mark - 地图开始拖动时调用
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    self.textField1.text = @"正在定位中";
    self.rightCustomButton.enabled = NO;   // 地图移动时保存按钮不能点击
    
}

#pragma mark - 地图移动时调用此方法
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status {
    CLLocationCoordinate2D cordinate = _mapView.centerCoordinate;
    _lat = [NSString stringWithFormat:@"%f",cordinate.latitude];
    _lon = [NSString stringWithFormat:@"%f",cordinate.longitude];
}

#pragma mark - 地图区域改变完成后调用
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // 获取屏幕中心点坐标
    CLLocationCoordinate2D cordinate = _mapView.centerCoordinate;
    CGFloat lat = cordinate.latitude;
    CGFloat lon = cordinate.longitude;
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){lat, lon};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch1 reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    self.rightCustomButton.enabled = YES;
}

#pragma mark - 反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
     // 在此处理正常结果
      dispatch_async(dispatch_get_main_queue(), ^{
          self.textField1.text = result.address;
          self.cordinate = result.location;
      });
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

#pragma mark - BMKLocationServiceDelegate
// 实现相关delegate 处理位置信息更新
// 处理方向变更信息  用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
    [_mapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 让地图挪动到对应的位置(经纬度交叉处)
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
    _isLegalTF1 = YES;
    _lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    _lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    CLLocationCoordinate2D cordinate = _mapView.centerCoordinate;
    CGFloat lat = cordinate.latitude;
    CGFloat lon = cordinate.longitude;
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){lat, lon};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch1 reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

// 用户位置更新后回调用此函数
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation {
    CGFloat locaLatitude = userLocation.location.coordinate.latitude;//纬度
    CGFloat locaLongitude = userLocation.location.coordinate.longitude;//精度
    BMKCoordinateRegion region;
    //将定位的点居中显示
    region.center.latitude = locaLatitude;
    region.center.longitude = locaLongitude;
    
    //反地理编码出地理位置
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){locaLatitude,locaLongitude};
    _mapView.region = region;
}

#pragma mark - 对输入框文字判断,是否是有效地址,地理编码
- (void)textFieldGeoSearchWithTextField:(UITextField *)textField {
    if (textField == _textField1) {
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city= @"上海";
        geoCodeSearchOption.address = textField.text;
        BOOL flag = [_geocodesearch1 geoCode:geoCodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
    } else {
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city= @"上海";
        geoCodeSearchOption.address = textField.text;
        BOOL flag = [_geocodesearch2 geoCode:geoCodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
    }
}
#pragma mark - 地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (_geocodesearch1 == searcher) {
            _lat = [NSString stringWithFormat:@"%f",result.location.latitude];
            _lon = [NSString stringWithFormat:@"%f",result.location.longitude];
            _isLegalTF1 = YES;
        } else {
            
            _latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
            _longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
            _isLegalTF2 = YES;
        }
    }
    else {
        if (_geocodesearch1 == searcher) {
            _textField1.textColor = OHColor(255, 96, 0, 1);
            _isLegalTF1 = NO;
            [OHCommon showWeakTips:@"该地址不存在，请重新输入" View:self.view];
        } else {
            _textField2.textColor = OHColor(255, 96, 0, 1);
            _isLegalTF2 = NO;
            [OHCommon showWeakTips:@"该地址不存在，请重新输入" View:self.view];
        }
    }
    
    // 地址输入错误时点击保存
    if (_isClickedRightBtn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self rightCustomButtonClick:nil];
        });
    }
}

#pragma mark - textfield文字变化时调用
- (void)textFieldTextDidChanged:(NSNotification *)not {
    if (not.object == _textField1) {
        if (_textField1.isEditing) {
            // 建议查询搜索
            BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
            option.cityname = @"上海";
            option.keyword  = _textField1.text;
            BOOL flag = [_suggestSearch suggestionSearch:option];
            if(flag)
            {
                NSLog(@"建议检索发送成功");
            }
            
            else
            {
                NSLog(@"建议检索发送失败");
            }
            
            // 点击textfiled时弹出一个建议搜索结果列表
            if (_textField1.text.length > 0) {
                [self createSuggestTableVieWithTextField:_textField1];
                
            } else {
                [self.suggestTableView removeFromSuperview];
            }
        }
    } else {
        if (_textField2.isEditing) {
            // 建议查询搜索
            BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
            option.cityname = @"上海";
            option.keyword  = _textField2.text;
            BOOL flag = [_suggestSearch suggestionSearch:option];
            if(flag)
            {
                NSLog(@"建议检索发送成功");
            }
            else
            {
                NSLog(@"建议检索发送失败");
            }
    
            if (_textField2.text.length > 0) {
                [self createSuggestTableVieWithTextField:_textField2];
            }else {
                [self.suggestTableView removeFromSuperview];
            }
        }
    }
    
}


- (UIView *)maskView {
    if (!_maskView) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, OHScreenW, OHScreenH - kNaviHeight)];
        self.maskView.backgroundColor = OHColor(0, 0, 0, 0.7);
    }
    return _maskView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
//    if (textField == _textField1) {
//        _isLegalTF1 = NO;
//    }else{
//        _isLegalTF2 = NO;
//    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];      // 隐藏键盘
    [self.maskView removeFromSuperview];   // 蒙层移除
    [self.suggestTableView removeFromSuperview];
    
    [self textFieldGeoSearchWithTextField:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    //开始编辑时触发，文本字段将成为first responder
//    [textField becomeFirstResponder];
    
    [self.mapView addSubview:self.maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOfMaskAction:)];
    [self.maskView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!_isLegalTF1) {
        [self textFieldShouldReturn:_textField1];
    }
    if (!_isLegalTF2) {
        [self textFieldShouldReturn:_textField2];
    }
}

#pragma mark - 建议搜索返回的结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.keyListArray = result.keyList;
        self.ptListArray = result.ptList;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
    [self.suggestTableView reloadData];
}

#pragma mark - 创建suggestTableView
- (void)createSuggestTableVieWithTextField:(UITextField *)tf {
    if (!_suggestTableView) {
        _suggestTableView = [[UITableView alloc] init];
        _suggestTableView.delegate = self;
        _suggestTableView.dataSource = self;
        [_suggestTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"suggestCell"];
        
        [self.view addSubview:_suggestTableView];
    }
    
    CGRect frame = CGRectMake(tf.origin.x, tf.origin.y+tf.size.height, OHScreenW -  48, 44 * 5);
    _suggestTableView.frame = frame;
    [self.view addSubview:_suggestTableView];
}

#pragma mark - tableViewDelegate 代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestCell"];
    
    cell.textLabel.text = self.keyListArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSString* selectedString = self.keyListArray[indexPath.row];
    
    NSValue *value = self.ptListArray[indexPath.row];
    CLLocationCoordinate2D coor;
    coor.latitude = value.CGPointValue.x;
    coor.longitude = value.CGPointValue.y;
    
//    if (_textField1.isEditing) {
//        _lat= [NSString stringWithFormat:@"%f",coor.latitude];
//        _lon = [NSString stringWithFormat:@"%f",coor.longitude];
//    } else {
//        _latitude = [NSString stringWithFormat:@"%f",coor.latitude];
//        _longitude = [NSString stringWithFormat:@"%f",coor.longitude];
    //    }
    _latitude = [NSString stringWithFormat:@"%f",coor.latitude];
    _longitude = [NSString stringWithFormat:@"%f",coor.longitude];
    
    if (self.textField1.isEditing) {
        self.textField1.text = selectedString;
        [self selectWithTextField:_textField1];
        _isLegalTF1 = YES;
        
    }else{
        self.textField2.text = selectedString;
        _isLegalTF2 = YES;
    }
    
    // 选中完cell赋值给textField后，清除suggestTableView
    [self.suggestTableView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keyListArray.count;
}

#pragma mark - 选中tableViewcell某行，定位到当前地址
- (void)selectWithTextField:(UITextField *)tf {
    if (tf.text.length > 0) {
        // 定位到指定位置
        CLLocationCoordinate2D coor;
        coor.latitude = [_latitude floatValue];
        coor.longitude = [_longitude floatValue];
        // 让地图挪动到对应的位置(经纬度交叉处)
        [_mapView setCenterCoordinate:coor animated:YES];
    } else {
        // 定位到当前位置
        if (tf == _textField1) {
            [self userLocation];
        }
    }
}


#pragma mark - 定位到当前位置
- (void)userLocation {
    _mapView.userTrackingMode = BMKUserTrackingModeFollow; //设置定位的状态
    [_locService startUserLocationService];
}

#pragma mark - centerButton响应时间
- (void)centerButtonAction:(UIButton *)btn {
    
}

#pragma mark - 地图添加手势，隐藏键盘，textfiled失去第一响应者
- (void)tapAction:(UITapGestureRecognizer *)tap {
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
//    [self.suggestTableView removeFromSuperview];
}

#pragma mark - 蒙层view的手势操作，移除蒙层
- (void)tapOfMaskAction:(UITapGestureRecognizer *)tap {
    [self.maskView removeFromSuperview];
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.suggestTableView removeFromSuperview];
    
    if (_textField1.isEditing) {
        [self textFieldGeoSearchWithTextField:_textField1];
    } else {
        [self textFieldGeoSearchWithTextField:_textField2];
    }
}

#pragma mark - 右侧保存按钮的点击事件
- (void)rightCustomButtonClick:(UIButton *)button {
    
    if (_textField1.isEditing) {
        _isClickedRightBtn = YES;
        [self textFieldShouldReturn:_textField1];
        [self.view endEditing:YES];
        return;
    }
    if (_textField2.isEditing) {
        _isClickedRightBtn = YES;
        [self textFieldShouldReturn:_textField2];
        [self.view endEditing:YES];
        return;
    }
    
    NSString *typeString = @"";
    if ([_titleString isEqualToString:@"工作区域"]) {
        typeString = @"work";
    }
    else {
        typeString = @"life";
    }
    
    if (self.textField1.text.length == 0) {
        _isLegalTF1 = NO;
    }
    if (self.textField2.text.length == 0) {
        _isLegalTF2 = NO;
    }
    
    // 根据内容传文字，没内容不传
    NSMutableArray *locationArray = @[].mutableCopy;
    if (_isLegalTF1) {
        [locationArray addObject:@{@"addrName":self.textField1.text,
                                  @"longitude":_lon,
                                   @"latitude":_lat
                                  }];
    }
    if (_isLegalTF2) {
        [locationArray addObject:@{@"addrName":self.textField2.text,
                                  @"longitude":_longitude,
                                   @"latitude":_latitude
                                  }];
    }
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [AFServer requestDataWithUrl:@"saveAddr" andDic:@{@"sessionId":kSessionId,
                                                            @"type":typeString,
                                                        @"dataList":locationArray
                                                      }
             completion:^(NSDictionary *dic) {
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 // block回调 这里要把在地图上选定的地点名称反向传给上个视图控制器(修改过后不需要传参数，上一页再次请求接口数据)
                 if (_callBack) {
                 _callBack(self.textField1.text, self.textField2.text);
                 }
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 
             } failure:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [OHCommon showWeakTips:@"服务器君已罢工，请稍后再试" View:self.view];
     
             }];
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
}

- (void)baseBackButtonClick {
    if (self.workDictionary) {
        // 上个页面传过来的地址
        NSString *workString1 = [self.workDictionary valueForKey:@"1"];
        NSString *workString2 = [self.workDictionary valueForKey:@"2"];
        
        if (!workString1) {
            workString1 = @"";
        }
        if (!workString2) {
            workString2 = @"";
        }
        
        NSString *tfNewString1 = self.textField1.text;
        NSString *tfNewString2 = self.textField2.text;
        
        if (![workString1 isEqualToString:tfNewString1] || ![workString2 isEqualToString:tfNewString2]) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要保存信息" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self rightCustomButtonClick:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:confirm];
            [self presentViewController:alertVC animated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        NSString *lifeString1 = [self.lifeDictionary valueForKey:@"1"];
        NSString *lifeString2 = [self.lifeDictionary valueForKey:@"2"];
        
        if (!lifeString1) {
            lifeString1 = @"";
        }
        if (!lifeString2) {
            lifeString2 = @"";
        }
        
        NSString *NewString1 = self.textField1.text;
        NSString *NewString2 = self.textField2.text;
        
        if (![lifeString1 isEqualToString:NewString1] || ![lifeString2 isEqualToString:NewString2]) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要保存信息" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self rightCustomButtonClick:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:confirm];
            [self presentViewController:alertVC animated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
}

@end
