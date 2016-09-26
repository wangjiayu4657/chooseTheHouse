//
//  OHHomeTopScreenView.h
//  OptionalHome
//
//  Created by haili on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//  首页筛选条件选择的view

#import <UIKit/UIKit.h>
#import "OHTextAndImageButton.h"
@protocol OHHomeTopScreenViewDelegate <NSObject>

/**
 *  筛选按钮的点击事件
 *
 *  @param btnIndex 按钮的tag值
 */
-(void)everyScreenBtnClick:(NSInteger)btnIndex btn:(OHTextAndImageButton *)btn;

@end

@interface OHHomeTopScreenView : UIView
@property (nonatomic, weak) id<OHHomeTopScreenViewDelegate> delegate;  //代理声明

@end
