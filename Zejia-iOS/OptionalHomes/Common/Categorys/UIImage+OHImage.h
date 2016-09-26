//
//  UIImage+OHImage.h
//  OptionalHome
//
//  Created by haili on 16/7/20.
//  Copyright © 2016年 haili. All rights reserved.
//  image 处理

#import <UIKit/UIKit.h>

@interface UIImage (OHImage)

/**
 *  设置UIImage的渲染模式
 *
 *  @param imageName imageName
 *
 *  @return 调整后的image
 */
+ (instancetype)orignalImageWithName:(NSString *)imageName;

/**
 *  根据颜色返回纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (instancetype)imageWithColor:(UIColor *)color;

/**
 *  返回原型图片
 *
 *  @return 处理过的原型图片
 */
- (UIImage *) circleImage ;

@end
