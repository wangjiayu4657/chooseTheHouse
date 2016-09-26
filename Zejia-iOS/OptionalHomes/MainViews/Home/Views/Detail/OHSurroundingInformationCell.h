//
//  OHSurroundingInformationCell.h
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHDetailModel;

@interface OHSurroundingInformationCell : UIView

/**自身高度*/
@property (assign , nonatomic)  CGFloat surroundViewHeight;

/**模型*/
@property (strong , nonatomic)  OHDetailModel *model;

/**社区 ID*/
@property (strong , nonatomic) NSNumber *communityId;

//+ (instancetype) showSourroundingInformationView;

@end
