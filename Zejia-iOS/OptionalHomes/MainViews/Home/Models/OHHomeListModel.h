//
//  OHHomeListModel.h
//  OptionalHome
//
//  Created by haili on 16/8/3.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHHomeListModel : NSObject

@property (nonatomic, strong) NSNumber *avgPrice;          //均价
@property (nonatomic, copy) NSString *communityName;       //社区名称
@property (nonatomic, copy) NSString *feature;             //特色
@property (nonatomic, strong) NSNumber *communityId;       //社区ID
@property (nonatomic, copy) NSString *panoUrl;             //社区全景地址
@property (nonatomic, copy) NSString *plate;               //片区
@property (nonatomic, copy) NSString *region;              //行政区
@property (nonatomic, strong) NSNumber *saleNum;           //在售房源数量
@property (nonatomic, copy) NSString *address;             //地址
@property (nonatomic, strong) NSNumber *isFollow;          //是否关注   1为关注，0为不关注
@property (nonatomic, strong) NSNumber *buildAge;          //建筑年代

@end
