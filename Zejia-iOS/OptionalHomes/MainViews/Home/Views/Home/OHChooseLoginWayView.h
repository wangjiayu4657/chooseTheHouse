//
//  OHChooseLoginWayView.h
//  OptionalHome
//
//  Created by haili on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//  首页选择登录方式的view

#import <UIKit/UIKit.h>
@protocol OHChooseLoginWayViewDelegate <NSObject>
/**
 *  按钮的点击事件(隐私说明按钮，各种登录方式按钮)
 *
 *  @param btnIndex 按钮的tag值
 */
-(void)everyBtnClick:(NSInteger)btnIndex;

@end

@interface OHChooseLoginWayView : UIView
@property (nonatomic, weak) id<OHChooseLoginWayViewDelegate> delegate;  //代理声明

@end
