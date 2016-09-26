//
//  OHTextAndImageButton.h
//  OptionalHome
//
//  Created by haili on 16/7/29.
//  Copyright © 2016年 haili. All rights reserved.
//  文字加图片的按钮

#import <UIKit/UIKit.h>

@interface OHTextAndImageButton : UIButton
@property(nonatomic, retain) UIImageView *buttomImage;
@property(nonatomic, retain) UILabel *buttomLable;
@property(nonatomic, assign) BOOL isSelected;         //是否选中
/**
 *  设置按钮的图片和标题
 *
 *  @param buttomImage 图片
 *  @param title       标题
 */
- (void)setButtomImage:(NSString *)buttomImage title:(NSString *)title;
/**
 *  根据fream设置按钮的图片和标题
 *
 *  @param buttomImage 按钮图片
 *  @param imageFrame  图片fream
 *  @param title       按钮的标题
 *  @param titleFrame  标题的fream
 */
- (void)setButtomImage:(NSString *)buttomImage imageFrame:(CGRect )imageFrame title:(NSString *)title titleFrame:(CGRect )titleFrame;
@end
