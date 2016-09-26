//
//  OHSetPassWordViewController.h
//  OptionalHome
//
//  Created by lujun on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//  设置密码

#import "OHBaseViewController.h"
@class OHLoginViewController;

@interface OHSetPassWordViewController : OHBaseViewController

@property (nonatomic, strong) OHLoginViewController *loginVC;
@property (nonatomic, copy) NSString *mobileNum;                //手机号

@end
