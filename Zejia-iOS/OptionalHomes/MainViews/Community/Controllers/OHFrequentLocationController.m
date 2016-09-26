//
//  OHFrequentLocationController.m
//  OptionalHome
//
//  Created by Dr_liu on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHFrequentLocationController.h"
#import "OHSettingPlaceController.h"
#import "OHHomeViewController.h"
#import "OHCommunityViewController.h"
#import "OHFrequentLocationModel.h"

@interface OHFrequentLocationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) OHSettingPlaceController *settingPlaceVC;
@property (nonatomic, strong) NSMutableDictionary *workDic;
@property (nonatomic, strong) NSMutableDictionary *lifeDic;

@end

@implementation OHFrequentLocationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    self.titleStr = @"常去地点";
    self.leftButtonStatus = leftButtonWithImage;
    self.leftCustomButtonImage = @"back_btn";
    [super viewDidLoad];
    self.view.backgroundColor = OHColor(230, 230, 230, 1);
    
    self.workDic = [NSMutableDictionary dictionary];
    self.lifeDic = [NSMutableDictionary dictionary];
    
    [self configData];
}
- (void)configData {
    self.frequentArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 调取获取常去地址列表
    [AFServer requestDataWithUrl:@"getAddrList" andDic:@{@"sessionId":kSessionId}
                      completion:^(NSDictionary *dic) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                          // 根据请求的数据再改
                          NSMutableArray *workArr = [NSMutableArray arrayWithCapacity:0];
                          NSMutableArray *lifeArr = [NSMutableArray arrayWithCapacity:0];
                          
                          if (dic[@"response"] != [NSNull null]) {
                              for (NSDictionary *frequentDic in [[dic objectForKey:@"response"] objectForKey:@"dataList"]) {
                                  OHFrequentLocationModel *frequentModel = [OHFrequentLocationModel mj_objectWithKeyValues:frequentDic];
                                  
                                  if ([frequentModel.type isEqualToString:@"work"]) {
                                      
                                      if (![frequentModel.addrName isEqual: [NSNull null]]) {
                                          [workArr addObject:frequentModel];
                                      }
                                  }
                                  else if ([frequentModel.type isEqualToString:@"life"]){
                                      [lifeArr addObject:frequentModel];
                                  }
                                  [self.frequentArray addObject:frequentModel];
                              }
                          }
                          
                          NSMutableArray *workStrArr = [NSMutableArray array];
                          for (OHFrequentLocationModel *model in workArr) {
                              [self.workDic setValue:model.addrName forKey:[NSString stringWithFormat:@"%ld",(long)model.ID]];
                              if (model.ID == 1) {   // 存下页textField1对应的坐标
                                  [self.workDic setValue:model.latitude forKey:@"lat"];
                                  [self.workDic setValue:model.longitude forKey:@"lon"];
                              }
                              
                              if (model.ID == 2) {   // 存下页textField2对应的坐标
                                  [self.workDic setValue:model.latitude forKey:@"latitude"];
                                  [self.workDic setValue:model.longitude forKey:@"longitude"];
                              }
                              [workStrArr addObject:model.addrName];
                          }
                          
                          NSMutableArray *lifeStrArr = [NSMutableArray array];
                          for (OHFrequentLocationModel *model in lifeArr) {
                              [self.lifeDic setValue:model.addrName forKey:[NSString stringWithFormat:@"%ld",(long)model.ID]];
                              if (model.ID == 1) {
                                  [self.lifeDic setValue:model.latitude forKey:@"lat"];
                                  [self.lifeDic setValue:model.longitude forKey:@"lon"];
                              }
                              if (model.ID == 2) {
                                  [self.lifeDic setValue:model.latitude forKey:@"latitude"];
                                  [self.lifeDic setValue:model.longitude forKey:@"longitude"];
                              }
                              [lifeStrArr addObject:model.addrName];
                          }
                          // 自动把数组转化为字符串，并且中间有换行
                          self.workString = [workStrArr componentsJoinedByString:@"\n"];
                          self.lifeString = [lifeStrArr componentsJoinedByString:@"\n"];
                          
                          [self config];
                          [self setCheckButton];
                      } failure:^(NSError *error) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [OHCommon showWeakTips:@"服务器君已罢工，请稍后再试" View:self.view];
                          
                      }];
}

- (void)config {
    self.workView.layer.cornerRadius = 8;
    self.liveView.layer.cornerRadius = 8;
    
    self.describeLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    self.describeLabel.textColor = OHColor(102, 102, 102, 1);
    
    self.workPlaceLabel.text = self.workString.length > 0?self.workString:@"工作地，学校";
    self.workPlaceLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    self.workPlaceLabel.contentMode = UIViewContentModeCenter;
    self.workPlaceLabel.textColor = self.workString.length>0?OHColor(254, 119, 0, 1):OHColor(153, 153, 153, 1);
    
    self.livePlaceLabel.text = self.lifeString.length > 0?self.lifeString:@"现在居住的地点，交际圈子地点";
    self.livePlaceLabel.font = [OHFont systemFontOfSize:14*kAdaptationCoefficient];
    self.livePlaceLabel.contentMode = UIViewContentModeCenter;
    self.livePlaceLabel.textColor = self.lifeString.length>0?OHColor(254, 119, 0, 1):OHColor(153, 153, 153, 1);
    
    CGFloat height = [OHCommon getLabelHeightWith:self.workPlaceLabel.text andWidth:CGRectGetWidth(self.workLabel.frame) andFont:14];
    CGRect frame = CGRectMake(CGRectGetMinX(self.workLabel.frame), CGRectGetMaxY(self.workLabel.frame), CGRectGetWidth(self.workLabel.frame), height);
    self.workPlaceLabel.frame = frame;
    CGFloat height1 = [OHCommon getLabelHeightWith:self.livePlaceLabel.text andWidth:CGRectGetWidth(self.liveLabel.frame) andFont:14];
    CGRect frame1 = CGRectMake(CGRectGetMinX(self.liveLabel.frame), CGRectGetMaxY(self.liveLabel.frame), CGRectGetWidth(self.liveLabel.frame), height1);
    self.livePlaceLabel.frame = frame1;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction1:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.workView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction2:)];
    tapGesture2.numberOfTapsRequired = 1;
    [self.liveView addGestureRecognizer:tapGesture2];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint pos = [touch locationInView:touch.view];
    if (pos.x <= self.workView.frame.size.width * 0.5) {
        return YES;
    }
    return NO;
}

#pragma mark - 手势的响应事件
- (void)tapGestureAction1:(UITapGestureRecognizer *)tap {
    NSLog(@"%@",tap.description);
    OHSettingPlaceController *settingPlaceVC = [[OHSettingPlaceController alloc] init];
    
    settingPlaceVC.titleString = self.workLabel.text;             // 把“工作区域”传到下级
    settingPlaceVC.textFieldString = self.workPlaceLabel.text;    // 把地点传给下页
    settingPlaceVC.workDictionary = self.workDic;                 // 把这页的地点通过字典传到下页
    
    // block回调选择的地点
    __weak typeof(self) weakSelf = self;
    settingPlaceVC.callBack = ^(NSString *saveString1, NSString *saveString2){
        
        // 回调之后重新请求链接
        [weakSelf.workDic removeAllObjects];
        [self configData];
        weakSelf.workPlaceLabel.text = weakSelf.workString.length > 0?weakSelf.workString:@"工作地，学校";
        weakSelf.livePlaceLabel.text = weakSelf.lifeString.length > 0?weakSelf.lifeString:@"现在居住的地点，交际圈子地点";
        weakSelf.workPlaceLabel.textColor = self.workString.length>0?OHColor(254, 119, 0, 1):OHColor(153, 153, 153, 1);
        weakSelf.livePlaceLabel.textColor = self.lifeString.length>0?OHColor(254, 119, 0, 1):OHColor(153, 153, 153, 1);
        CGFloat height = [OHCommon getLabelHeightWith:self.workPlaceLabel.text andWidth:CGRectGetWidth(self.workLabel.frame) andFont:14];
        CGRect frame = CGRectMake(CGRectGetMinX(self.workLabel.frame), CGRectGetMaxY(self.workLabel.frame), CGRectGetWidth(self.workLabel.frame), height);
        self.workPlaceLabel.frame = frame;
        CGFloat height1 = [OHCommon getLabelHeightWith:self.livePlaceLabel.text andWidth:CGRectGetWidth(self.liveLabel.frame) andFont:14];
        CGRect frame1 = CGRectMake(CGRectGetMinX(self.liveLabel.frame), CGRectGetMaxY(self.liveLabel.frame), CGRectGetWidth(self.liveLabel.frame), height1);
        self.livePlaceLabel.frame = frame1;
    };
    
    [self.navigationController pushViewController:settingPlaceVC animated:YES];
}
- (void)tapGestureAction2:(UITapGestureRecognizer *)tap {
    NSLog(@"%@",tap.description);
    OHSettingPlaceController *settingPlaceVC = [[OHSettingPlaceController alloc] init];
    
    settingPlaceVC.titleString = self.liveLabel.text;
    settingPlaceVC.textFieldString = self.livePlaceLabel.text;
    settingPlaceVC.lifeDictionary = self.lifeDic;
    
    __weak typeof(self) weakSelf = self ;
    settingPlaceVC.callBack = ^(NSString *saveString1, NSString *saveString2){
        [weakSelf.lifeDic removeAllObjects];
        [weakSelf configData];
        weakSelf.workPlaceLabel.text = weakSelf.workString.length > 0?weakSelf.workString:@"工作地，学校";
        weakSelf.livePlaceLabel.text = weakSelf.lifeString.length > 0?weakSelf.lifeString:@"现在居住的地点，交际圈子地点";
        weakSelf.workPlaceLabel.textColor = self.workString.length>0?OHColor(254, 119, 0, 1):OHColor(153, 153, 153, 1);
        weakSelf.livePlaceLabel.textColor = self.lifeString.length>0?OHColor(254, 119, 0, 1):OHColor(153, 153, 153, 1);
        CGFloat height = [OHCommon getLabelHeightWith:self.workPlaceLabel.text andWidth:CGRectGetWidth(self.workLabel.frame) andFont:14];
        CGRect frame = CGRectMake(CGRectGetMinX(self.workLabel.frame), CGRectGetMaxY(self.workLabel.frame), CGRectGetWidth(self.workLabel.frame), height);
        self.workPlaceLabel.frame = frame;
        CGFloat height1 = [OHCommon getLabelHeightWith:self.livePlaceLabel.text andWidth:CGRectGetWidth(self.liveLabel.frame) andFont:14];
        CGRect frame1 = CGRectMake(CGRectGetMinX(self.liveLabel.frame), CGRectGetMaxY(self.liveLabel.frame), CGRectGetWidth(self.liveLabel.frame), height1);
        self.livePlaceLabel.frame = frame1;
    };
    
    [self.navigationController pushViewController:settingPlaceVC animated:YES];
}

- (void)setCheckButton {
    if ([self.workString isEqualToString:@"\n"]) {
        self.workString = @"";
    }
    if ([self.lifeString isEqualToString:@"\n"]) {
        self.lifeString = @"";
    }
    if (self.workString.length > 0 || self.lifeString.length > 0) {
        _checkButton.backgroundColor = OHColor(252, 229, 88, 1);
        [_checkButton setTintColor:OHColor(160, 160, 160, 1]);
        _checkButton.userInteractionEnabled = YES;
    }
    else {
        _checkButton.backgroundColor = OHColor(239, 239, 239, 1);
        [_checkButton setTintColor:OHColor(105, 49, 25, 1]);
        _checkButton.userInteractionEnabled = NO;
    }
}

- (IBAction)checkButton:(UIButton *)sender {
    // 选完所有的标签页后存一个值在本地，做标示，首页需要判断进登录还是列表
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"InHome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[[self.navigationController viewControllers] objectAtIndex:0] isKindOfClass:[OHHomeViewController class]]) {
        OHHomeViewController *homeVC = [[self.navigationController viewControllers] objectAtIndex:0] ;
        [homeVC resetSomeThing];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        OHHomeViewController *homeVC = [[OHHomeViewController alloc] init];
        [self.navigationController pushViewController:homeVC animated:YES];
    }

}
@end
