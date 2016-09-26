//
//  OHCommunityViewController.h
//  OptionalHome
//
//  Created by Dr_liu on 16/7/26.
//  Copyright © 2016年 haili. All rights reserved.
//

#import "OHBaseViewController.h"

@interface OHCommunityViewController : OHBaseViewController

@property(strong,nonatomic) NSMutableArray* nextPageArray;

@property (nonatomic, strong) NSMutableArray *idArray;

@property (nonatomic, copy) NSMutableString *idString; // 保存标签

@end
