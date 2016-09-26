//
//  OHSettingPlaceController.h
//  OptionalHome
//
//  Created by Dr_liu on 16/7/28.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHBaseViewController.h"

@interface OHSettingPlaceController : OHBaseViewController

@property (nonatomic, copy) NSString *titleString;     // 接收上个页面传的标题名称

@property (nonatomic, copy) NSString *textFieldString; // 接收上个页面传的 工作／生活 地址信息

@property (nonatomic, copy) void(^callBack)(NSString *saveString1, NSString *saveString2);

@property (nonatomic, strong) NSMutableDictionary *workDictionary;   // 从上个页面的字典workDic中取值，赋给文本框

@property (nonatomic, strong) NSMutableDictionary *lifeDictionary;

@end
