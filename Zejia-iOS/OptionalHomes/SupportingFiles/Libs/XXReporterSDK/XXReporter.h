//
//  XXReporter.h
//  XuSDK
//
//  Created by rong on 16/6/14.
//  Copyright © 2016年 rc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define CYReporterVersion @"1.0.0"


typedef NS_ENUM(NSInteger, CYReportMode)
{
    CYReportModeFollowTimeInterval,
    
    CYReportModeFollowLogCount,
    
    CYReportModeFollowLogSize,
    
    CYReportModeFollowConstant
};

@class PageModel;
@class ElementViewNode;
@class CircleChooseButtom;

@interface XXReporter : NSObject

@property (nonatomic,strong) UIView * coverView;
@property (nonatomic,strong) ElementViewNode * node;
@property (nonatomic,strong) UIView * targetView;
@property (nonatomic,assign) BOOL isCircleChoose;
@property (nonatomic,strong) UIViewController * currentVC;
@property (nonatomic,strong) CircleChooseButtom * chooseBtn;
@property (nonatomic,strong) NSMutableString * tmpString;

@property (nonatomic,strong) NSMutableDictionary * expandDic;

@property (nonatomic,strong) PageModel * pageModel;
+ (instancetype)shareReporter;
+ (void)addPageModelToArr:(PageModel *)pageModel;
+ (NSMutableArray *)getPageModelArr;
+ (PageModel *)getPageModel;

/**
 *App启动时调用改方法，打印启动日志
 */
+ (void)startWithAppID:(NSString *)appid channelID:(NSString *)channelid;


/**
 * 设置uid方法，只在登陆成功处调用此方法
 */
+ (void)setUserID:(NSString *)uid;

/**
 * 登出操作，将uid置为空
 */
+ (void)userLogOut;

/**
 *添加程序崩溃日志收集方法
 */
+ (void)crashLog;

/**
 * 是否开启日志测试接口（此方法用于正式环境和测试环境接口的切换）
 */
+ (void)isOpenTestLog:(BOOL)isOpen;


@end
