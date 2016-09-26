//
//  OHModifyNickNameViewController.h
//  OptionalHome
//
//  Created by lujun on 16/8/3.
//  Copyright © 2016年 haili. All rights reserved.
//  修改昵称

#import "OHBaseViewController.h"

@protocol OHModifyNickNameViewControllerDelegate <NSObject>

- (void)reloadUserInfoDataComeFromModifyNickNameVC;         //刷新个人信息页数据

@end

@interface OHModifyNickNameViewController : OHBaseViewController

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, weak) id<OHModifyNickNameViewControllerDelegate> delegate;

@end
