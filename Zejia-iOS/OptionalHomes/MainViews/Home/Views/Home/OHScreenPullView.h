//
//  OHScreenPullView.h
//  OptionalHome
//
//  Created by haili on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//  首页筛选的下拉View

#import <UIKit/UIKit.h>
#import "OHTextAndImageButton.h"
@class OHScreenPullView;
@protocol OHScreenPullViewDelegate <NSObject>
/**
 *  选中某行的代理
 *
 *  @param selectView OHScreenPullView
 *  @param btnTag     按钮的tag值
 *  @param selectStr  选中的行对应的文字
 *  @param index      选中的行
 */
- (void)selectTableRow:(OHScreenPullView *)selectView btnTag:(NSInteger)btnTag selectStr:(NSString *)selectStr selectIndex:(NSString *)index;
@end
@interface OHScreenPullView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *selectTableView;  //选择的表
@property (nonatomic, copy) NSString *selectName;           //选中的选项的内容
@property (nonatomic, strong ) UIView *backView;            //背景
@property (nonatomic, strong ) UIView *contentView;         //内容view
@property (nonatomic, strong ) NSArray *selectArr;         //选择的数组
@property (nonatomic, weak) id <OHScreenPullViewDelegate >delegate;
@property (nonatomic, strong) OHTextAndImageButton *selectBtn;  //筛选的按钮

//初始化
- (void)initWithselecttArr;
//视图出现
- (void)setView;
//视图消失
- (void)endView;

@end
