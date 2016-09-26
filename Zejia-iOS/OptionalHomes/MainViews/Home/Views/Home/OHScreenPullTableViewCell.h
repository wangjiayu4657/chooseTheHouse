//
//  OHScreenPullTableViewCell.h
//  OptionalHome
//
//  Created by haili on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHScreenModel.h"
@interface OHScreenPullTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *titleLabel;           //标题label
@property(nonatomic, strong) UIImageView *selectImageView;  //选中的图片ImageView

/**
 *  设置cell的内容
 *
 *  @param model  模型
 *  @param selectStr 选中的文字
 */
-(void)setCellWith:(OHScreenModel *)model andSelectStr:(NSString *)selectStr;

@end
