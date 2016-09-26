//
//  OHBaseViewController.h
//  OptionalHome
//
//  Created by haili on 16/7/18.
//  Copyright © 2016年 haili. All rights reserved.
//  基类 ViewController

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, RightButtonStatus)
{
    rightButtonWithNone = 0,        //没有右侧按钮
    rightButtonWithTitle,           //有右侧按钮，且带标题
    rightButtonWithImage,           //有右侧按钮，且带图片
};

typedef NS_ENUM(NSInteger, LeftButtonStatus)
{
    leftButtonWithNone = 0,         //没有左侧按钮
    leftButtonWithTitle,            //有左侧按钮，且带标题
    leftButtonWithImage,            //有左侧按钮，且带图片
};

@interface OHBaseViewController : UIViewController

@property (nonatomic, assign) BOOL leftCanPanEnabled;                  //侧滑抽屉是否可以手势滑动（默认不能）
@property (nonatomic, assign) BOOL canDragBack;                        // 是否有滑动返回效果（默认有）
@property (nonatomic, assign) BOOL isShowNaviView;                      //是否显示导航栏 （默认显示）

@property (nonatomic, strong) UIView *naviView;                         //导航
@property (nonatomic, strong) UIButton *backButton;                     //返回按钮
@property (nonatomic, strong) UIButton *rightCustomButton;              //右侧自定义按钮
@property (nonatomic, strong) UILabel *titleLabel;                      //标题label
@property (nonatomic, copy) NSString *titleStr;                         //导航栏标题

@property (nonatomic, assign) RightButtonStatus rightButtonStatus;
@property (nonatomic, copy) NSString *rightCustomButtonTitle;           //右侧按钮标题
@property (nonatomic, copy) NSString *rightCustomButtonImage;           //右侧按钮图标

@property (nonatomic, assign) LeftButtonStatus leftButtonStatus;
@property (nonatomic, copy) NSString *leftCustomButtonTitle;            //左侧按钮标题
@property (nonatomic, copy) NSString *leftCustomButtonImage;            //左侧按钮图标

//自定义导航栏
- (void)initCustomNaviView;
////设置是否可以手势拖出抽屉
//-(void)setLeftViewPanStatus;

@end
