//
//  OHDetailMapController.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/8.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHBaseViewController.h"
#import "OHDetailModel.h"
typedef enum : NSUInteger {
    FoodPeripheryType = 1<<2,
    PlayPeripheryType,
    StudyPeripheryType,
    BuyPeripheryType,
    HospitalPeripheryType,
    AllPeripheryType
} PeripheryType;

// 吃玩学买医
@interface OHDetailMapController : OHBaseViewController

@property (nonatomic, copy) NSString *communityId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, assign) PeripheryType type;
@property (nonatomic, strong) OHDetailModel *model;
@end
