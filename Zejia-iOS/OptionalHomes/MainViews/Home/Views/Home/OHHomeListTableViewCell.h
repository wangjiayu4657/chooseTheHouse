//
//  OHHomeListTableViewCell.h
//  OptionalHome
//
//  Created by haili on 16/8/2.
//  Copyright © 2016年 haili. All rights reserved.
//  首页列表的cell

#import <UIKit/UIKit.h>
#import "OHHomeListModel.h"

typedef void (^attentionBlock) (UIButton *);

@interface OHHomeListTableViewCell : UITableViewCell

@property(nonatomic,copy)attentionBlock attentionBlock;//是否关注的按钮

-(void)setCellWith:(OHHomeListModel *)model;

@end
