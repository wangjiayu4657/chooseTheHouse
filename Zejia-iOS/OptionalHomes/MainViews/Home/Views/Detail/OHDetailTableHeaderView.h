//
//  OHDetailTableHeaderView.h
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OHDetailModel;

@interface OHDetailTableHeaderView : UIView

/** 自身的高度*/
@property (assign , nonatomic) CGFloat headerViewHeight;
/**模型*/
@property (strong , nonatomic)  OHDetailModel *model;

@property (strong , nonatomic) void (^completed)(NSString *states);

//@property (strong , nonatomic) void (^showFinishedBlock)(CGFloat height);

/**社区 ID*/
@property (strong , nonatomic) NSNumber *communityId;

+ (instancetype) showTableHeaderView;

@end
