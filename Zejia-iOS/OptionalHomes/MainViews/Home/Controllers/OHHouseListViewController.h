//
//  OHHouseListViewController.h
//  OptionalHome
//
//  Created by lujun on 16/8/6.
//  Copyright © 2016年 haili. All rights reserved.
//  房源列表页

#import "OHBaseViewController.h"

@interface OHHouseListViewController : OHBaseViewController

@property (nonatomic, copy) NSString *communityId;      //社区Id
@property (nonatomic, copy) NSString *site;             //房源网站(@"lianjia"或者@"soufun")

@end
