//
//  OHDetailModel.h
//  OptionalHome
//
//  Created by fangjs on 16/8/3.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHDetailModel : NSObject

/** 社区ID  (Long) **/
@property (strong , nonatomic) NSNumber *communityId;

/** 是否关注 (int)  1为关注，0为不关注 **/
@property (assign , nonatomic) int isFollow;

/** 社区名称   (string) **/
@property (strong , nonatomic) NSString *communityName;

/**region	行政区 (string)*/
@property (strong , nonatomic) NSString *region;

/**plate	片区(string)*/
@property (strong , nonatomic) NSString *plate;

/** 社区全景图地址 (string) **/
@property (strong , nonatomic) NSString *panoUrl;

/** 全景的h5页面地址 (string) **/
@property (strong , nonatomic) NSString *pano360Url;

/** 经度   (string) **/
@property (strong , nonatomic) NSString *longitude;

/** 纬度   (string) **/
@property (strong , nonatomic) NSString *latitude;

/** 社区地址   (string) **/
@property (strong , nonatomic) NSString *address;

/** 容积率   (float) **/
//@property (assign , nonatomic) float capacityRate;
@property (strong , nonatomic) NSNumber *capacityRate;

/** 绿化率   (float) **/
//@property (assign , nonatomic) float greenRate;
@property (strong , nonatomic) NSNumber *greenRate;

/** 建筑年代  (string) **/
@property (strong , nonatomic) NSString *buildAge;

/** 房屋总数 (int) **/
@property (assign , nonatomic) int houseCount;

/** 占地面积 (int) **/
@property (assign , nonatomic) int area;

/** 户均车位 (string)  **/
@property (strong , nonatomic) NSString *parkCount;

/** 均价   (float) **/
//@property (assign , nonatomic) float avgPrice;
@property (strong , nonatomic) NSNumber *avgPrice;

/** 周边吃的数量(int) **/
@property (assign , nonatomic) int chi;

/** 周边吃的餐厅名称 ，逗号分隔 **/
@property (strong , nonatomic) NSString *chiName;

/** 周边玩的数量(int) **/
@property (assign , nonatomic) int wan;

/** 周边玩的地点名称，逗号分隔 **/
@property (strong , nonatomic) NSString *wanName;

/** 周边学校数量(int) **/
@property (assign , nonatomic) int xue;

/** 周边学校名称，逗号分隔 **/
@property (strong , nonatomic) NSString *xueName;

/** 周边购物数量(int) **/
@property (assign , nonatomic) int mai;

/** 周边购物地点名称，逗号分隔 **/
@property (strong , nonatomic) NSString *maiName;

/** 周边医院数量(int) **/
@property (assign , nonatomic) int yi;

/** 周边医院名称，逗号分隔 **/
@property (strong , nonatomic) NSString *yiName;

/**房源站点列表*/
@property (strong , nonatomic) NSArray *siteList;

@property (strong , nonatomic) NSArray *houseList;

@end
