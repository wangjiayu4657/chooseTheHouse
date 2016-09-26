//
//  OHMyAttentionsModel.h
//  OptionalHome
//
//  Created by lujun on 16/8/4.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMyAttentionsModel : NSObject

@property (nonatomic, strong) NSNumber *ID;             //社区id
@property (nonatomic, copy) NSString *thumbUrl;         //缩略图地址
@property (nonatomic, copy) NSString *name;             //社区名称
@property (nonatomic, copy) NSString *region;           //行政区域
@property (nonatomic, copy) NSString *plate;            //片区
@property (nonatomic, copy) NSString *avgPrice;         //均价
@property (nonatomic, copy) NSString *buildAge;         //建筑年代

@end
