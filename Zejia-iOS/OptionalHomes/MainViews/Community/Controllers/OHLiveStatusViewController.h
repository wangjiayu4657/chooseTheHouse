//
//  OHLiveStatusViewController.h
//  OptionalHome
//
//  Created by Dr_liu on 16/8/2.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHBaseViewController.h"

@interface OHLiveStatusViewController : OHBaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;  // 传过来的type3的数据

@property (nonatomic, copy) NSString *idStrings;  // 保存的所有标签id

@property (nonatomic, strong) NSMutableArray *isCheckedArray;

@property (nonatomic, strong) NSMutableArray *myNewIdArray;  // 存放"社区特色"选中id的数组

@property (nonatomic, strong) NSMutableArray *mainArray;    // 存放生活状态,选中标签的ID数组

@end
