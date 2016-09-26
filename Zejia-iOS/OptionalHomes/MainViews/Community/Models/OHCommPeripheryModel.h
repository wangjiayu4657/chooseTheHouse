//
//  OHCommPeripheryModel.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/10.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHCommPeripheryModel : NSObject

@property (nonatomic, copy) NSString *name;      // 名称
@property (nonatomic, copy) NSString *address;   // 地址
@property (nonatomic, copy) NSString *distance;  // 距离
@property (nonatomic, copy) NSString *latitude;  // 纬度
@property (nonatomic, copy) NSString *longitude; // 经度
@property (nonatomic, copy) NSString *costs;     // 评分
@property (nonatomic, copy) NSString *type;      // 类型
@end
