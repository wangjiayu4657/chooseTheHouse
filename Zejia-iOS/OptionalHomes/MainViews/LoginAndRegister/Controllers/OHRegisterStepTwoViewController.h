//
//  OHRegisterStepTwoViewController.h
//  OptionalHome
//
//  Created by lujun on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//  手机注册页-第二步

#import "OHBaseViewController.h"
@class OHLoginViewController;

@interface OHRegisterStepTwoViewController : OHBaseViewController

@property (nonatomic, strong) OHLoginViewController *loginVC;
@property (nonatomic, copy) NSString *mobileNum;                //手机号

@end
