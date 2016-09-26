//
//  OHDetailCellModel.h
//  OptionalHome
//
//  Created by fangjs on 16/8/3.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHDetailCellModel : NSObject

/**: id(long)*/
@property (assign , nonatomic) double ID;

/**:房源缩略图地址(string)*/
@property (strong , nonatomic) NSString *logo;

/**:名称(string)*/
@property (strong , nonatomic) NSString *title;

/** (string)*/
@property (strong , nonatomic) NSString *layout;

/**:面积(float)*/
@property (assign , nonatomic) float  area;

/** 均价(float)*/
@property (assign , nonatomic) float  avgPrice;

/**:销售价格(float)*/
@property (assign , nonatomic) float  sellPrice;

/**地址 url*/
@property (strong , nonatomic) NSString *infoUrl;


@end
