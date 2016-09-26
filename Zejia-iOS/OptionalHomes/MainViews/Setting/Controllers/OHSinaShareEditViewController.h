//
//  OHSinaShareEditViewController.h
//  ClockClassroom
//
//  Created by lujun on 15/12/29.
//  Copyright © 2015年 EjuChina. All rights reserved.
//  意见反馈页

#import "OHBaseViewController.h"

@interface OHSinaShareEditViewController : OHBaseViewController<UITextViewDelegate>

@property(nonatomic, copy)   NSString *shareContent;            //分享的内容
@property(nonatomic, copy)   NSString *shareURL;                //分享的链接
@property(nonatomic, strong) UIImageView *shareImageView;       //分享的图片

@end
