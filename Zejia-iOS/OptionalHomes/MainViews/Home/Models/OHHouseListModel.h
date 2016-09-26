//
//  OHHouseListModel.h
//  OptionalHome
//
//  Created by lujun on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHHouseListModel : NSObject

@property (nonatomic, strong) NSNumber *ID;             //房源id
@property (nonatomic, copy) NSString *logo;             //缩略图地址
@property (nonatomic, copy) NSString *title;            //名称
@property (nonatomic, copy) NSString *layout;           //户型
@property (nonatomic, copy) NSString *area;             //面积
@property (nonatomic, copy) NSString *orientation;      //朝向
@property (nonatomic, copy) NSString *feature;          //房属性
@property (nonatomic, copy) NSString *price;            //销售价格
@property (nonatomic, copy) NSString *avgPrice;         //均价
@property (nonatomic, copy) NSString *infoUrl;          //详情网址，跳转到该网址所指页面

@end
