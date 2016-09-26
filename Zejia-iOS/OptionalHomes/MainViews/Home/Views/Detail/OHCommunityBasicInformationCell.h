//
//  OHCommunityBasicInformationCell.h
//  OptionalHome
//
//  Created by fangjs on 16/8/1.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OHDetailModel;

@interface OHCommunityBasicInformationCell : UIView

/**自身高度*/
@property (assign , nonatomic)  CGFloat basicInformationViewHeight;

/**模型*/
@property (strong , nonatomic)  OHDetailModel *model;

+ (instancetype)showBasicInformationView;
@end
