//
//  OHLeftTableViewCell.h
//  OptionalHome
//
//  Created by haili on 16/7/27.
//  Copyright © 2016年 haili. All rights reserved.
//  左侧抽屉栏的cell

#import <UIKit/UIKit.h>

@interface OHLeftTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *titleImage;
@property (nonatomic,strong) UILabel *titleLabel;
/**
 *  设置cell的内容
 *
 *  @param imageName 图片名
 *  @param title     标题
 */
-(void)setCellWithImage:(NSString *)imageName title:(NSString *)title;
@end
